HTTPI.adapter = :net_http

module SUNAT
  module Delivery
    class Sender
      attr_reader :name, :encoded_zip, :operation, :client, :operation


      ADDRESSES = {:homologation => "https://www.sunat.gob.pe/ol-ti-itcpgem-sqa/billService?wsdl",
                   :production => "https://www.sunat.gob.pe/ol-ti-itcpfegem/billService?wsdl",                                  
                   :test => "https://www.sunat.gob.pe:443/ol-ti-itcpgem-beta/billService?wsdl"}
        

      def address
        ADDRESSES[SUNAT.environment]
      end

      def initialize
        @credentials = credentials
      end

      def connect
        @client ||= new_client
      end

      def connect!
        @client = new_client
      end

      def submit_file(name, encoded_zip)
        need_credentials do
          connect
          response = client.call :send_bill, message: {
            fileName: "#{name}.zip",
            contentFile: encoded_zip
          }
          BillResponse.new(response.body)
        end
      end

      def submit_summary(name, encoded_zip)
        need_credentials do
          connect
          response = client.call :send_summary, message: {
            fileName: "#{name}.zip",
            contentFile: encoded_zip
          }
          SummaryResponse.new(response.body)
        end
      end

      def get_status(ticket)
        need_credentials do
          connect
          response = client.call :get_status, message: { ticket: ticket }
          StatusResponse.new(response.body)
        end
      end

      private

      def new_client
        login     = @credentials.login
        password  = @credentials.password

        Savon.client(
          wsdl:               address,
          namespace:          "http://service.sunat.gob.pe",
          wsse_auth:          [login, password],
          ssl_cert_file:      cert_file,
          ssl_cert_key_file:  pk_file,
          ssl_version:        :SSLv23
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
