module SUNAT
  module Delivery
    class Chef
      attr_reader :name, :document
      
      def initialize(name, document)
        @name = name
        @document = document
      end
      
      def prepare
        byte_array zip
      end
    
      def zip
        zipper.zip_file(@name, @document)
      end
    
      def byte_array(zip_str)
        Base64.encode64(zip_str)
      end
      
      private
      
      def zipper
        @zipper ||= Zipper.new
      end
    end
  end
end