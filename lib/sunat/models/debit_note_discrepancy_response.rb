module SUNAT
  class DebitNoteDiscrepancyResponse < DiscrepancyResponse
    validates :response_code, inclusion: {:in => ANNEX::CATALOG_10}
  end
end