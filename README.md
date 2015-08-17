[![Build Status](https://travis-ci.org/cabify/sunat-ruby.svg?branch=master)](https://travis-ci.org/cabify/sunat-ruby)

# SUNAT Declaration Generator

Easily generate declarations for SUNAT, Peru's state tax collection entity.

## Installation

Add this line to your application's Gemfile:

    gem 'sunat', github: 'cabify/sunat-ruby'

And then execute:

    $ bundle

##QuickStart
Pull this repo and check the **examples** folder.
In this folder you can find a playground set to test Sunat Invoicing and mess arround with it.
You can find in each directory some files.
* **Ruby File** - This is the important file. We use it to create a XML File and also a PDF file
* **Sunat XML** Example
* Our **generated XML** - XML File with the data we added in the ruby file
* Our **generated pdf** - Just a visual reference to our XML File. Made for humans :)

Using this examples you can see how to deal with Sunat.

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


After writing your config file lets proceed with our keys generation

You can get some certificates to work with using this command

	openssl genrsa -des3 -out server.key 1024
	openssl genrsa -des3 -out cert.key 1024
	openssl req -new -key cert.key -out cert.csr
	openssl rsa -in server.key.org -out server.key
	openssl rsa -in cert.key -out cert.key
	openssl x509 -req -days 365 -in cert.csr -signkey cert.key -out cert.crt

Name them as you want to, but remember to replace your config.rb file to use them. If you want to pass sunat homologation process you should use Sunat approved certificates, you can do it verifying them at their webpage


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

Or you can replace them in the config.rb file. But remember not to push it to any public place!
## Serialization

Every model can be serialized and de-serialized from JSON. This is extremely useful for storing a declaration a more readily usable form.

## Homologation

SUNAT requires that all clients of their system first go through a homolgation process to test all possible combinations of invoices, receipts, credit and debit notes, and summary documents.

Its an increadibly teadious process made more frustrating by the fact you probably only need a couple of standard documents for your project. Fortunately, this library makes the process a bit simpler by including the default set of test cases. Simply enter the `homologation` directory, create your own `config.rb` file, and call `ruby homologation.rb`. All the defined cases will be executed.

You can also provide as a param the groups of cases that you need to execute calling `ruby homologation.rb 1,4,12`




## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Write and fix some tests if you feel like doing it.
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request describing what you've done


## Authors

Creation of the sunay-ruby library was sponsored by Cabify.



