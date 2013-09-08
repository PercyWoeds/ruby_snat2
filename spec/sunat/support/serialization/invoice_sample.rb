Invoice.new.tap do |invoice|
  invoice.id  = "FF11-00000001"
  
  # TODO: Research this for all the documents.
  # 
  # invoice.additional_monetary_totals << MonetaryTotal.new({
  #   id: '1001',
  #   payable_amount:   PaymentAmount.new(currency: 'PEN', value: 10000),
  #   reference_amount: PaymentAmount.new(currency: 'PEN', value: 10000),
  #   total_amount:     PaymentAmount.new(currency: 'PEN', value: 20000),
  # })
  # 
  # invoice.add_additional_property(id: '20000', value: 'COMPROBANTE DE PERCEPCION')
  
  invoice.ruc         = "20100113612"
  invoice.legal_name  = "K&G Laboratorios"
  
  invoice.customer = {ruc: '20382170114', name: 'CECI FARMA IMPORT S.R.L.'}
  
  invoice.lines << {
    :quantity => 300,
    :price => 67800,
    :list_price => 70000,
    :total => 172890,
    :item => {
      :description => "Sample Item"
    },
    :tax_totals => [
      {
        :amount => 26231,
        :type => :igv
      },
      {
        :amount => 8745,
        :type => :isc
      }
    ]
  }

  invoice.tax_totals << {
    :amount => 26231,
    :type => :igv
  }

  invoice.tax_totals << {
    :amount => 8745,
    :type => :isc
  }
  


end
