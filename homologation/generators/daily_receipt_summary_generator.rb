require_relative 'document_generator'

class DailyReceiptSummaryGenerator < DocumentGenerator
  def initialize()
    super("daily receipt summary", 0)
  end

  def generate
    issue_date = Date.new(2012, 6, 24)
    correlative_number = "001"
    daily_receipt_summary_data = {reference_date: Date.new(2012, 6, 23), issue_date: issue_date, id: SUNAT::DailyReceiptSummary.generate_id(issue_date, correlative_number), correlative_number: correlative_number,
                              lines: [{line_id: "1", document_type_code: "03", document_serial_id: "BA98", start_id: "456", end_id: "764", 
                                  billing_payments: [{paid_amount: 9823200, instruction_id: "01"}, {paid_amount: 0, instruction_id: "02"}, {paid_amount: 23200, instruction_id: "03"}],
                                  allowance_charges: [{amount: 500, charge_indicator: 'true'}], tax_totals: [{amount: 1768176, type: :igv}, {amount: 0, type: :isc}, {amount: 120000, type: :other}]},
                                  {line_id: "2", document_type_code: "03", document_serial_id: "BC23", start_id: "789", end_id: "932", 
                                  billing_payments: [{paid_amount: 7822300, instruction_id: "01"}, {paid_amount: 2442300, instruction_id: "02"}, {paid_amount: 0, instruction_id: "03"}],
                                  allowance_charges: [{amount: 0, charge_indicator: 'true'}], tax_totals: [{amount: 1408014, type: :igv}, {amount: 0, type: :isc}]},
                                  {line_id: "3", document_type_code: "07", document_serial_id: "BC11", start_id: "23", end_id: "89", 
                                  billing_payments: [{paid_amount: 2322300, instruction_id: "01"}, {paid_amount: 0, instruction_id: "02"}, {paid_amount: 0, instruction_id: "03"}],
                                  allowance_charges: [{amount: 0, charge_indicator: 'true'}], tax_totals: [{amount: 418014, type: :igv}, {amount: 0, type: :isc}]},
                                  {line_id: "4", document_type_code: "03", document_serial_id: "BD21", start_id: "12", end_id: "230", 
                                  billing_payments: [{paid_amount: 7124200, instruction_id: "01"}, {paid_amount: 7882900, instruction_id: "02"}, {paid_amount: 510300, instruction_id: "03"}],
                                  allowance_charges: [{amount: 34500, charge_indicator: 'true'}], tax_totals: [{amount: 1282356, type: :igv}, {amount: 234200, type: :isc}]},
                                  {line_id: "5", document_type_code: "08", document_serial_id: "B234", start_id: "902", end_id: "1459", 
                                  billing_payments: [{paid_amount: 6443400, instruction_id: "01"}, {paid_amount: 0, instruction_id: "02"}, {paid_amount: 1256795, instruction_id: "03"}],
                                  allowance_charges: [{amount: 0, charge_indicator: 'true'}], tax_totals: [{amount: 1159812, type: :igv}, {amount: 0, type: :isc}]}]
                              }
    daily_receipt_summary = SUNAT::DailyReceiptSummary.new(daily_receipt_summary_data)

    generate_documents(daily_receipt_summary)
    daily_receipt_summary
  end

  def generate_documents(document)
    if document.valid?
      ticket = document.deliver!
      document_status = ticket.get_status
      while document_status.in_process?
        document_status = ticket.get_status
      end
      if document_status.error?
        file_name = "daily_recipt_error.zip"
        document_status.save_content_to(file_name)
        puts "Daily Receipt wasn't generated succesfully, check #{file_name} to see why"
      end
    else
      raise "Invalid daily receipt: #{document.errors}"
    end
  end
end