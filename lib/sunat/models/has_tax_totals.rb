module SUNAT
  module HasTaxTotals
    def add_tax_total(tax_name, amount, currency)      
      tax_total = TaxTotal.new({
        :amount => amount,
        :type => tax_name
      })
      tax_totals << tax_total
    end
  end
end