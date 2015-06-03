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
    end
  end
end