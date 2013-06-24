module SUNAT
  #
  # The receipt summary is one of the primary or root models. It can be
  # used to generate an XML document suitable for presentation.
  #
  
  class DailyReceiptSummary < Document
    
    SUMMARY_TYPE = 'RC' # Look Sunat's Programmer's manual page 6
    
    xml_root :SummaryDocuments
    
    property :id,                   String
    property :reference_date,       Date
    property :lines,                [SummaryDocumentsLine]
    property :notes,                [String]
    
    validates :lines, not_empty: true
    
    def initialize
      super
      self.notes  ||= []
      self.lines  ||= []
      self.id     ||= default_id
    end
    
    def file_name
      formatted_issue_date = issue_date.strftime("%Y%m%d")
      "#{ruc}-#{SUMMARY_TYPE}-#{formatted_issue_date}-#{correlative_number}"
    end
    
    def to_xml
      super do |xml|
        notes.each do |note|
          xml['cbc'].Note note
        end
        
        accounting_supplier_party.build_xml xml, :AccountingSupplierParty
        
        lines.each do |line|
          line.build_xml xml
        end
      end
    end
    
    private
    
    def default_id
      plain_date = Date.today.strftime("%Y%m%d")
      "RC-#{plain_date}"
    end
    
  end
end