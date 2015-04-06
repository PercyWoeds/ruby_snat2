module SUNAT

  # The sunat Model module is included into a model to allow support for serialization,
  # validation, and simple typecasting.
  module Model
    extend ActiveSupport::Concern

    include ActiveModel::Validations

    included do
      include Castable
      include Attributes
      include Properties
      include Validations

      validate do 
        properties_to_check = []
        klass = self.class
        while klass.respond_to? :properties
          properties_to_check += klass.properties.keys
          klass = klass.superclass
        end
        
        properties_to_check.each do |property|
          value = get_attribute(property)
          value = [value] unless value.is_a? CastedArray
          value.each do |element|
            validate_value(property, element)  
          end
        end
      end
    end

    def initialize(attrs = {})
      # Use the `Properties` module's `#set_attribtues` method
      set_attributes(attrs)
    end

    def validate_value(property, value)
      unless property_valid?(value)
        value.errors.full_messages.each {|error| errors.add(property, error)}
      end
    end

    def property_valid?(value)
      valid = true
      valid = value.valid? if value.respond_to?(:valid?)
      valid
    end

    module ClassMethods
      # Little help. Equivalent to new.tap
      def build(*attrs)
        instance = self.new(*attrs)
        yield instance if block_given?
        instance
      end
    end

  end

end
