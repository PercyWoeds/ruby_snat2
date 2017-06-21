class DocumentGenerator
  TYPES = {"SUNAT::Invoice"  => "01", "SUNAT::Receipt" => "03"}
    @@document_serial_id = 5
    
  attr_reader :group, :group_case

  def initialize(group, group_case)
    @group = group
    @group_case = group_case
  end


  def generate_documents(document, pdf=false)
    if document.valid?
     begin
      document.to_pdf 
      
     document.deliver!
      rescue Savon::SOAPFault => e
      puts "Error generating document for case #{group_case} in group #{group}: #{e}"
      end
      document.to_pdf if pdf
    else
     raise "Documento invalido para caso #{group_case} in group #{group}, ignoring output: #{document.errors.messages}"
  end
  end
end
