module SUNAT  
  class PricingReference
    include Model
    
    property :alternative_condition_price, AlternativeConditionPrice
    
    def initialize(*args)
      super(parse_attributes(*args))
    end
    
    def build_xml(xml)
      xml['cac'].PricingReference do
        alternative_condition_price.build_xml xml
      end
    end

    protected

    def parse_attributes(attrs = {})
      case attrs
      when Integer
        attrs = {
          :alternative_condition_price => {
            :price_amount => attrs
          }
        }
      else
        amt  = attrs.delete(:amount)
        free = attrs.delete(:free)
        if amt
          self.alternative_condition_price = {
            :price_amount => amt,
            :free => free
          }
        end
      end
      attrs
    end
    
  end
end
