class Minidoc::DuplicateKey < Mongo::OperationFailure
  DUPLICATE_KEY_ERROR_CODE = 11000

  def self.duplicate_key_exception(exception)
    if exception.respond_to?(:error_code) && exception.error_code == DUPLICATE_KEY_ERROR_CODE
      new(exception.message, exception.error_code, exception.result)
    else
      nil
    end
  end

end
