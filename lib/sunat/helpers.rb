module SUNAT
  class Helpers

    def self.textify(paymentAmount, lang=:es)
      text = I18n.with_locale(lang) {paymentAmount.int_part.to_words}
      currency = Currency.new(paymentAmount.currency)
      currency_text = currency.plural_name || paymentAmount.currency
      "#{text} y #{paymentAmount.cents_part}/100 #{currency_text}"
    end

  end
end