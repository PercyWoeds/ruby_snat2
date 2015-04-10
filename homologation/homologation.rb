lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'sunat'
require './config'

class DocumentGenerator
  def self.generate_documents(group, group_case, document, pdf=false)
    if document.valid?
      File::open("#{document.file_name}.xml", "w") { |file| file.write(document.to_xml) }
      #document.deliver!
      document.to_pdf if pdf
    else
      raise "Invalid document for case #{group_case} in group #{group}, ignoring output: #{document.errors.messages}"
    end
  end
end

class InvoiceGenerator < DocumentGenerator
  @@invoice_serial_id = 1
  
  def self.generate_invoice_with_igv(group, group_case, items, serie, pdf=false)
    invoice_data = {id: "FF11-#{"%03d" % @@invoice_serial_id}", customer: {legal_name: "Servicabinas S.A.", ruc: "20587896411"}}
    @@invoice_serial_id += 1
    lines = []
    invoice_data[:lines] = (1..items).map do |item|
      {id: item.to_s, quantity: 1, line_extension_amount: 10000, pricing_reference: 11800, price: 10000, tax_totals: [{amount: 1800, type: :igv}],
        item: {id: item.to_s, description: "Item #{item}"}}
    end
    invoice_data[:legal_monetary_total] = 11800 * items
    invoice_data[:additional_monetary_totals] = [{id: "1001", payable_amount: 10000 * items}]
    invoice = SUNAT::Invoice.new(invoice_data)
    generate_documents(1,1, invoice, pdf)
  end
  
end

files_to_clean = Dir.glob("*.xml") + Dir.glob("./pdf_output/*.pdf")
files_to_clean.each do |file|
  File.delete(file)
end
#Groupo 1
InvoiceGenerator.generate_invoice_with_igv(1,1,3, "FF11")
InvoiceGenerator.generate_invoice_with_igv(1,2,2, "FF11")
InvoiceGenerator.generate_invoice_with_igv(1,3,1, "FF11", true)
InvoiceGenerator.generate_invoice_with_igv(1,4,5, "FF11")
InvoiceGenerator.generate_invoice_with_igv(1,5,4, "FF11")
