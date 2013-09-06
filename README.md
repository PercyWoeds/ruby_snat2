# SUNAT Declaration Generator

Easily generate declarations for SUNAT, Peru's state tax collection entity.

## Installation

Add this line to your application's Gemfile:

    gem 'sunat'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sunat

## Configuration

Prepare the SUNAT library by defining the configuration somewhere in your project as follows:

  SUNAT.configure do |config|
    config.credentials do |c|
      # Regular credentials provided by SUNAT
      c.ruc       = "123456780"
      c.username  = "USERNAME"
      c.password  = "PASSWORD"
    end
    
    config.signature do |s|
      # A company ID (Should be RUC)
      s.party_id    = "20100454523"

      # The name of the company
      s.party_name  = "SOPORTE TECNOLOGICO EIRL"

      # SUNAT validated certificate
      s.cert_file   = File.join(Dir.pwd, 'config', 'keys', 'sunat.crt')

      # Password-less private key used to sign certificate
      s.pk_file     = File.join(Dir.pwd, 'config', 'keys', 'sunat.key')
    end

    # General Company details to be included in every document generated.
    # Only used if no alternative is provided.
    config.supplier do |s|
      s.ruc        = "20100454523"
      s.name       = "SOPORTE TECNOLOGICO EIRL"
      s.address_id = "070101"
      s.street     = "Calle los Olivos 234"
      s.city       = "Lima"
      s.district   = "Callao"
      s.country    = "PE"
    end


  end




## Testing

Set the next ENV variables: SUNAT_RUC, SUNAT_USERNAME and SUNAT_PASSWORD.
They must be secret!

In Fish:

  set -gx SUNAT_RUC ruc # ruc
  set -gx SUNAT_USERNAME username # sol user
  set -gx SUNAT_PASSWORD password # sol password

In Bash:
  
  export SUNAT_RUC=ruc # ruc
  export SUNAT_USERNAME=username # sol user
  export SUNAT_PASSWORD=password # sol password


## Serialization

Every model can be serialized and de-serialized from JSON. This is extremely useful for storing a declaration a more readily usable form.


## Homologation

SUNAT requires that all clients of their system first go through a homolgation process to test all possible combinations of invoices, receipts, credit and debit notes, and summary documents.

Its an increadibly teadious process made more frustrating by the fact you probably only need a couple of standard documents for your project. Fortunately, this library makes the process a bit simpler by including the default set of test cases. Simply enter the `homologation` directory, create your own `config.rb` file, and call rake. All of the available yaml definitions in the `cases` directory will be compiled and sent to SUNAT using your own details.




## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## Authors

Creation of the sunay-ruby library was sponsored by Cabify.



