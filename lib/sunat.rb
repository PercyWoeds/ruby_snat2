require "sunat/version"

# The dependencies are isolated into one file.
# The reason is because they can be loaded
# independently by zeus or another test utility.
require "sunat/dependencies"

# Annex
require "sunat/annex"

# Construction and Signature
require "sunat/supplier"
require "sunat/signature"
require "sunat/credentials"
require "sunat/config"
require "sunat/xml_document"
require "sunat/xml_signer"


# Modules and classes that can be autoloaded
module SUNAT

  # Base support modules
  autoload :Castable,    "sunat/castable"
  autoload :CastedArray, "sunat/casted_array"
  autoload :Attributes,  "sunat/attributes"
  autoload :Properties,  "sunat/properties"
  autoload :Property,    "sunat/property"
  autoload :Validations, "sunat/validations"
  autoload :Model,       "sunat/model"
  autoload :Helpers,     "sunat/helpers"

  # Base Document
  autoload :Document, "sunat/document"

  # Documents
  autoload :CreditNote,          "sunat/documents/credit_note"
  autoload :DailyReceiptSummary, "sunat/documents/daily_receipt_summary"
  autoload :DebitNote,           "sunat/documents/debit_note"
  autoload :Invoice,             "sunat/documents/invoice"
  autoload :Receipt,             "sunat/documents/receipt"

  # Models
  autoload :AccountingCustomerParty,   "sunat/models/accounting_customer_party"
  autoload :AccountingSupplierParty,   "sunat/models/accounting_supplier_party"
  autoload :AdditionalMonetaryTotal,   "sunat/models/additional_monetary_total"
  autoload :AdditionalProperty,        "sunat/models/additional_property"
  autoload :AllowanceCharge,           "sunat/models/allowance_charge"
  autoload :AlternativeConditionPrice, "sunat/models/alternative_condition_price"
  autoload :BillingPayment,            "sunat/models/billing_payment"
  autoload :Country,                   "sunat/models/country"
  autoload :CreditNoteLine,            "sunat/models/credit_note_line"
  autoload :DebitNoteLine,             "sunat/models/debit_note_line"
  autoload :DiscrepancyResponse,       "sunat/models/discrepancy_response"
  autoload :DocumentReference,         "sunat/models/document_reference"
  autoload :HasTaxTotals,              "sunat/models/has_tax_totals"
  autoload :InvoiceLine,               "sunat/models/invoice_line"
  autoload :Item,                      "sunat/models/item"
  autoload :Party,                     "sunat/models/party"
  autoload :PartyLegalEntity,          "sunat/models/party_legal_entity"
  autoload :PaymentAmount,             "sunat/models/payment_amount"
  autoload :PhysicalLocation,          "sunat/models/physical_location"
  autoload :PostalAddress,             "sunat/models/postal_address"
  autoload :PricingReference,          "sunat/models/pricing_reference"
  autoload :Quantity,                  "sunat/models/quantity"
  autoload :ReferralGuideline,         "sunat/models/referral_guideline"
  autoload :SummaryDocumentsLine,      "sunat/models/summary_documents_line"
  autoload :TaxCategory,               "sunat/models/tax_category"
  autoload :TaxScheme,                 "sunat/models/tax_scheme"
  autoload :TaxSubTotal,               "sunat/models/tax_sub_total"
  autoload :TaxTotal,                  "sunat/models/tax_total"

  # Delivery Preparation
  module Delivery
    autoload :Zipper, "sunat/delivery/zipper"
    autoload :Chef,   "sunat/delivery/chef"
    autoload :Sender, "sunat/delivery/sender"
  end

end

