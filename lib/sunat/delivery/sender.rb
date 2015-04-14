HTTPI.adapter = :net_http

module SUNAT
  module Delivery
    class Sender
      attr_reader :name, :encoded_zip, :operation, :client, :operation
      
      # PRODUCTION
      # WSDL = "https://www.sunat.gob.pe/ol-ti-itcpgem/billService?wsdl"

      # HOMOLOGATION
      WSDL = "https://www.sunat.gob.pe/ol-ti-itcpgem-sqa/billService?wsdl"
      
      def initialize(name, encoded_zip, operation)
        @operation = operation
        @encoded_zip = encoded_zip
        @name = name
        @credentials = credentials
      end
      
      def connect
        @client ||= new_client
      end
      
      def connect!
        @client = new_client
      end
      
      def call
        need_credentials do
          connect
          response = client.call operation, message: {
            fileName: "#{name}.zip",
            contentFile: encoded_zip
          }
          response
        end
      end
      
      private
      
      def new_client
        login     = @credentials.login
        password  = @credentials.password
        
        Savon.client(
          wsdl:               WSDL,
          namespace:          "http://service.sunat.gob.pe",
          wsse_auth:          [login, password],
          ssl_cert_file:      cert_file,
          ssl_cert_key_file:  pk_file,
          ssl_version:        :SSLv3
        )
      end
      
      def credentials
        SUNAT::CREDENTIALS
      end
      
      def cert_file
        SUNAT::SIGNATURE.cert_file
      end
      
      def pk_file
        SUNAT::SIGNATURE.pk_file
      end
      
      def need_credentials
        if @credentials.nil?
          raise "We need credentials object to be filled"
        else
          yield
        end
      end
    end
  end
end
