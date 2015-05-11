require_relative 'document_generator'

class VoidedDocumentsGenerator < DocumentGenerator
  def initialize()
    super("voided documents", 0)
  end

  def generate
    voided_documents_data = {reference_date: Date.new(2011,4,1), issue_date: Date.new(2011,4,2), id: "RA-20110401-001", correlative_number: "001",
                         lines: [{line_id: "1", document_type_code: "01", document_serial_id: "F001", document_number_id: "1", void_reason: "Error en sistema"},
                                 {line_id: "2", document_type_code: "01", document_serial_id: "F001", document_number_id: "15", void_reason: "Cancelacion"}]}

    voided_document = SUNAT::VoidedDocuments.new(voided_documents_data)

    generate_documents(voided_document, false)
    voided_document
  end
end