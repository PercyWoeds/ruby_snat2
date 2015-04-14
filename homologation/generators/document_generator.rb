class DocumentGenerator
  TYPES = {"SUNAT::Invoice" => "01", "SUNAT::Receipt" => "03"}
  @@document_serial_id = 1

  attr_reader :group, :group_case

  def initialize(group, group_case)
    @group = group
    @group_case = group_case
  end

  def generate_documents(document, pdf=false)
    if document.valid?
      #File::open("#{document.file_name}.xml", "w") { |file| file.write(document.to_xml) }
      document.deliver!
      document.to_pdf if pdf
    else
      raise "Invalid document for case #{group_case} in group #{group}, ignoring output: #{document.errors.messages}"
    end
  end
end