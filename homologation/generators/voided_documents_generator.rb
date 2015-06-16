require_relative 'document_generator'

class VoidedDocumentsGenerator < DocumentGenerator
  def initialize()
    super("voided documents", 0)
  end

  def generate
    issue_date = Date.new(2011,4,2)
    correlative_number = "001"
    voided_documents_data = {reference_date: Date.new(2011,4,1), issue_date: issue_date, id: SUNAT::VoidedDocuments.generate_id(issue_date, correlative_number), correlative_number: correlative_number,
                         lines: [{line_id: "1", document_type_code: "01", document_serial_id: "F001", document_number_id: "1", void_reason: "Error en sistema"},
                                 {line_id: "2", document_type_code: "01", document_serial_id: "F001", document_number_id: "2", void_reason: "Cancelacion"},
                                 {line_id: "3", document_type_code: "01", document_serial_id: "F001", document_number_id: "3", void_reason: "Cancelacion"},
                                 {line_id: "4", document_type_code: "01", document_serial_id: "F001", document_number_id: "4", void_reason: "Cancelacion"},
                                 {line_id: "5", document_type_code: "01", document_serial_id: "F001", document_number_id: "5", void_reason: "Cancelacion"}]}

    voided_document = SUNAT::VoidedDocuments.new(voided_documents_data)

    generate_documents(voided_document)
    voided_document
  end

  def generate_documents(document)
    if document.valid?
      ticket = document.deliver!
      document_status = ticket.get_status
      while document_status.in_process?
        document_status = ticket.get_status
      end
      if document_status.error?
        file_name = "voided_document_error.zip"
        document_status.save_content_to(file_name)
        puts "Voided Document wasn't generated succesfully, check #{file_name} to see why"
      end
    else
      raise "Invalid voided document: #{document.errors}"
    end
  end
end