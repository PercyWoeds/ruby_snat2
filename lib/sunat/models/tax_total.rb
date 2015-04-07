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
    property :sub_total,  TaxSubTotal
    
    validates :tax_amount, presence: true
    validates :sub_total, presence: true

    def initialize(*args)
      super(parse_attributes(*args))
    end
    
    def build_xml(xml)
      xml['cac'].TaxTotal do
        tax_amount.build_xml xml, :TaxAmount
        sub_total.build_xml(xml)
      end
    end
    
    def tax_amount
      get_attribute(:tax_amount) || calculate_total
    end

    def sub_total_amount
      if sub_total.present?
        sub_total.tax_amount.value
      else
        0
      end
    end

    def tax_type_name
      sub_total.tax_category.tax_scheme.name
    end

    private

    def calculate_total
      PaymentAmount.new(sub_total_amount)
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
        self.sub_total = sub
      end
      attrs
    end
    
  end

end
