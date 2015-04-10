class DocumentGenerator
  TYPES = {"SUNAT::Invoice" => "01", "SUNAT::Receipt" => "03"}
  @@document_serial_id = 1
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