require 'zip'

module SUNAT
  module Delivery
    class Zipper
      def zip(name, body)
        zip = Zip::OutputStream.write_buffer do |zip|
          zip.put_next_entry name
          zip.write body
        end
        zip.rewind
        zip.sysread
      end
    end
  end
end