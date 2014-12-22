module SUNAT

  class SummaryDocumentsLine
    include Model
    include HasTaxTotals

    property :line_id,            String
    property :serial_id,          String
    property :start_id,           String
    property :end_id,             String
    property :document_type_code, String
    property :total_amount,       PaymentAmount
    property :billing_payments,   [BillingPayment]
    property :allowance_charges,  [AllowanceCharge]
    property :tax_totals,         [TaxTotal]
    property :item,               Item
    property :quantity,           Quantity
    
    [:line_id, :serial_id, :start_id, :end_id].each do |field|
      validates field, existence: true, presence: true
    end

    TABLE_HEADERS = ["ITEM", "CANTIDAD", "UNIDAD", "DESCRIPTION", "VALOR TOTAL"]
    
    validates :document_type_code, tax_document_type_code: true
    
    def initialize(*args)
      super(*args)
      self.billing_payments   ||= []
      self.allowance_charges  ||= []
      self.tax_totals         ||= []
      self.document_type_code ||= receipt_document_code
    end
    
    def add_billing_payment(code, amount, currency = "PEN")
      payment = BillingPayment.new.tap do |billing|
        billing.paid_amount    = PaymentAmount[amount, currency]
        billing.instruction_id = code
      end
      billing_payments << payment
    end
    
    def add_allowance_charge(amount, currency)
      add_allowance_amount(amount: amount, currency: currency, is_discount: false)
    end
    
    def add_allowance_discount(amount, currency)
      add_allowance_amount(amount: amount, currency: currency, is_discount: true)
    end
    
    # 
    # Calculates automatically the total amount.
    # There is a gotcha: If not all the payments
    # are from the same money, this method won't
    # calculate the total amount because this gem
    # doesn't force the user to use a exchange
    # service.
    # 
    def total_amount
      common_currency = calculate_common_currency
      if common_currency.nil?
        self[:total_amount]
      else
        self[:total_amount] ||= PaymentAmount[calculate_total, common_currency]
      end
    end
    
    def build_pdf_table_row(pdf)
      row = []
      row << self.line_id
      row << self.quantity.quantity
      row << self.quantity.unit_code
      row << "#{self.item.description} - #{self.item.id}"
      row << "#{self.total_amount.value} #{self.total_amount.currency}"
      row
    end

    def build_xml(xml)
      xml['sac'].SummaryDocumentsLine do
        xml['cbc'].LineID                 line_id
        xml['cbc'].DocumentTypeCode       document_type_code
        xml['sac'].DocumentSerialID       serial_id
        xml['sac'].StartDocumentNumberID  start_id
        xml['sac'].EndDocumentNumberID    end_id
        
        total_amount.tap do |amount|
          amount.xml_namespace = 'sac'
        end.build_xml xml, 'TotalAmount'
        
        tax_totals.each do |total|
          total.build_xml xml
        end
        
        allowance_charges.each do |charge|
          charge.build_xml xml
        end
        
        billing_payments.each do |billing_payment|
          billing_payment.build_xml xml
        end
      end
    end
    
    private
    
    def add_allowance_amount(options)
      amount = options[:amount]
      currency = options[:currency]
      is_discount = options[:is_discount]
      
      allowance_entity = AllowanceCharge.new
      allowance_entity.charge_indicator = (!is_discount).to_s
      allowance_entity.amount = PaymentAmount[amount, currency]
      
      allowance_charges << allowance_entity
    end
    
    def receipt_document_code
      SUNAT::Receipt::DOCUMENT_TYPE_CODE
    end
    
    def calculate_common_currency
      currencies = all_payments.map(&:currency)
      (currencies.any? && currencies.uniq.size == 1) ? currencies.first : nil
    end
    
    def calculate_total
      all_payments.inject(0) do |total, payment|
        total + payment.value
      end
    end
    
    def all_payments
      billing_payments.map(&:paid_amount) + allowance_charges.map(&:amount) + tax_totals.map(&:tax_amount)
    end
    
  end

end
