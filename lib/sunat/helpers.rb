module SUNAT
  class Helpers

    def self.textify(paymentAmount, lang=:es, currency="nuevos soles")
      text = I18n.with_locale(lang) {paymentAmount.int_part.to_words}
      "#{text} y #{paymentAmount.cents_part}/100 #{currency}"
    end

  end
end