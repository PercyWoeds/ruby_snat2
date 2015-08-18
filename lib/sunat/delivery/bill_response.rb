module SUNAT
  module Delivery
    class BillResponse
      CORRECT_CODE = 0
      RESPONSE_CODE_KEY = 'cbc:ResponseCode'
      RESPONSE_DESCRIPTION_KEY = 'cbc:Description'

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
        @code ||= Nokogiri::XML(data.first).xpath("//#{RESPONSE_CODE_KEY}").first.text.to_i
      end

      def description
        @description ||= Nokogiri::XML(data.first).xpath("//#{RESPONSE_DESCRIPTION_KEY}").first.text
      end

      private

      def zipper
        @zipper ||= Zipper.new
      end

      def data
        @data ||= zipper.read_string(Base64.decode64(@content))
      end
    end
  end
end
