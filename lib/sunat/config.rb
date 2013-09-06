# The Default Signature, Certificate, and Supplier are initially empty
SUNAT::SIGNATURE   = SUNAT::Signature.new
SUNAT::CREDENTIALS = SUNAT::Credentials.new
SUNAT::SUPPLIER    = SUNAT::Supplier.new

class SUNAT::ConfigurationDSL  
  def credentials
    yield SUNAT::CREDENTIALS
  end
  
  def signature
    yield SUNAT::SIGNATURE
  end

  def supplier
    yield SUNAT::SUPPLIER
  end

end

# Allow override the default signature and certificate in a DSL-like style
def SUNAT.configure
  yield SUNAT::ConfigurationDSL.new
end
