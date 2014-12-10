#
# Grupo 1 a 4 - Facturas de Ventas
#
# Set environment variables, then run:
#
#    ruby invoices.rb
#

lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'sunat'
require './config'


# Group 1

doc = SUNAT::Invoice.new

doc.ruc            = doc.signature.party_id
doc.legal_name     = doc.signature.party_name

doc.add_line do |line|
	line.price = 3000
	line.id = "PENIS"
end

doc.id = "FF11-000001"
puts doc.to_xml

