module SUNAT
  module Delivery

    CORRECT_CODE = 0
    IN_PROCESS_CODE = 98
    ERROR_CODE = 99

    class StatusResponse
      def initialize(response_body)
        @status_code = response_body[:get_status_response][:status][:status_code].to_i
        @content = response_body[:get_status_response][:status][:content]
      end
      
      def in_process?
        @status_code == IN_PROCESS_CODE
      end

      def correct?
        @status_code == CORRECT_CODE
      end

      def error?
        @status_code == ERROR_CODE
      end

      def save_content_to(file_name)
        File.open(file_name, "wb"){|file| file << Base64.decode64(@content)}
      end
    end
  end
end