module SUNAT
  class CreditNoteDiscrepancyResponse < DiscrepancyResponse
    validates :response_code, inclusion: {:in => ANNEX::CATALOG_09}
  end
end