class Minidoc::DuplicateKey < StandardError
  DUPLICATE_KEY_ERROR_CODE = "E11000".freeze

  def self.duplicate_key_exception(ex)
    if ex.is_a?(Mongo::Error::OperationFailure) && ex.message.starts_with?(DUPLICATE_KEY_ERROR_CODE)
      new(ex.message)
    end
  end
end
