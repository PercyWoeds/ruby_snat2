module SUNAT
  class Currency
    CURRENCIES = {pen: {singular: 'nuevo sol', plural: 'nuevos soles'},
                  eur: {singular: 'euro', plural: 'euros'},
                  usd: {singular: 'dolar', plural: 'dolares'}}
    
    def initialize(code)
      @code = code.downcase.to_sym
    end

    def singular_name
      CURRENCIES[@code][:singular] if CURRENCIES[@code].present?
    end

    def plural_name
      CURRENCIES[@code][:plural] if CURRENCIES[@code].present?
    end
  end
end