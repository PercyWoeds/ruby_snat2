module SUNAT
  module Delivery
    class BillResponse
      CORRECT_CODE = 0
      RESPONSE_CODE_KEY = 'cbc:ResponseCode'

      attr_reader :content

      def initialize(response_body)
        @content = response_body[:send_bill_response][:application_response]
      end

      def correct?
        status_code == CORRECT_CODE
      end

      def error?
        !correct?
      end

      def status_code
        @code ||=  begin
                    data = zipper.read_string(Base64.decode64(@content))
                    Nokogiri::XML(data.first).xpath("//#{RESPONSE_CODE_KEY}").first.text.to_i
                  end
      end

      private

      def zipper
        @zipper ||= Zipper.new
      end
    end
  end
end
