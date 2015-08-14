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

      def zip_file(name, body)
        zipfile_name = name.gsub(".xml", ".zip")
        Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
          zipfile.get_output_stream(name) { |f| f.puts body }
        end
        File.read(zipfile_name)
      end

      def read_string(zip_string)
        data = []

        Zip::File.open_buffer(zip_string) do |zip|
          decompressed_data = ''
          zip.each do |entry|
            decompressed_data += entry.get_input_stream.read
          end
          data << decompressed_data
        end

        data
      end
    end
  end
end
