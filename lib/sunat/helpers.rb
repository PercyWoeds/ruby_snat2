module SUNAT
  class Helpers

    def self.textify(number, lang=:es, currency="nuevos soles")
      decimal = number.to_s.split(".")[1]
      decimal = "00" if decimal == "0" or decimal.nil? # Sunat way
      text = I18n.with_locale(lang) {number.to_i.to_words}
      "#{text} y #{decimal}/100 #{currency}"
    end

  end
end