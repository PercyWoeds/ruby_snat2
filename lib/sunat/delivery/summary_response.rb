module SUNAT
  module Delivery
    class SummaryResponse
      
      attr_reader :ticket
      
      def initialize(response_body)
        @ticket = response_body[:send_summary_response][:ticket]
      end

      def get_status
        sender.get_status(@ticket)
      end

      def sender
        @sender ||= Sender.new
      end
    end
  end
end