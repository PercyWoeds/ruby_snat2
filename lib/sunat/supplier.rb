module SUNAT

  # Support class for providing a general supplier to be used
  # by default in all delarations where no alternative is provided.
  class Supplier
   
    KEYS = :name, :ruc, :address_id, :street, :zone, :city, :province, :district, :country

    attr_accessor *KEYS

    def as_hash
      attrs = {}
      KEYS.each do |k|
        v = send(k)
        attrs[k] = v unless v.nil?
      end
      attrs
    end

  end
end
