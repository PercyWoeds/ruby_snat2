module SUNAT
  
  class AlternativeConditionPrice
    include Model
    
    property :price_amount, PaymentAmount
    property :price_type,   String # TODO: Range in Catalog # 16
  end
  
  class PriceReference
    include Model
    
    property :alternative_condition_prices, [AlternativeConditionPrice]
    
    def initialize
      self.alternative_condition_prices = []
    end
  end
end