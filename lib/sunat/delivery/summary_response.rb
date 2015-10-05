module SUNAT
  module Delivery
    class SummaryResponse

      attr_reader :ticket

      def initialize(response ={})
        @ticket = response[:ticket] || response[:send_summary_response][:ticket]
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
