module SUNAT

  # The SUNAT TaxTotal is used for both a complete invoice and
  # individual lines.
  #
  # If no 'tax_amount' is provided, it will be calculated automatically
  # when generating XML.
  #
  # To try and make the process of generating a total tax object
  # simpler, the following set of helper attributes are provided.
  # 
  #  * :amount - amount of taxes to pay
  #  * :type - the TaxScheme definition, should be one of :igv, :isc, or :other
  #  * :tier - For ISC taxes, should be option from ANNEX::CATALOG_08
  #  * :code - Type of IGV code from ANNEX::CATALOG_07. Confusingly, this is 
  #    normally called :tax_exemption_reason_code.
  #
  class TaxTotal
    include Model

    property :tax_amount, PaymentAmount
    property :sub_totals, [TaxSubTotal]
    
    def initialize(*args)
      self.sub_totals ||=[]
      super(parse_attributes(*args))
    end
    
    def build_xml(xml)
      xml['cac'].TaxTotal do
        tax_amount.build_xml xml, :TaxAmount
        sub_totals.each do |sub_total|
          sub_total.build_xml(xml)
        end
      end
    end
    
    def tax_amount
      get_attribute(:tax_amount) || calculate_total
    end

    private
    
    def calculate_total
      amount = 0
      sub_totals.each do |sub|
        amount += sub.tax_amount.value
      end
      PaymentAmount.new(amount)
    end

    def parse_attributes(attrs = {})
      amount = attrs.delete(:amount)
      type   = attrs.delete(:type)
      tier   = attrs.delete(:tier)
      code   = attrs.delete(:code)
      if amount && type
        sub = TaxSubTotal.new({
          :tax_amount => amount,
          :tax_category => {
            :tax_scheme                => type,
            :tier_range                => tier,
            :tax_exemption_reason_code => code
          }
        })
        # Special conditions for :igv and :isc to set defaults
        case type
        when :igv
          sub.tax_category.tax_exemption_reason_code ||= ANNEX::CATALOG_07.first
        when :isc
          sub.tax_category.tier_range ||= ANNEX::CATALOG_08.first
        end
        self.sub_totals << sub
      end
      attrs
    end
    
  end

end
