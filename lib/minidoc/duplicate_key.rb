class Minidoc::DuplicateKey < StandardError
  DUPLICATE_KEY_ERROR_CODE = 11000

  def self.duplicate_key_exception(ex)
    if ex.is_a?(Mongo::Error::OperationFailure) && ex.message.end_with?("(#{DUPLICATE_KEY_ERROR_CODE})")
      new(ex.message)
    end
  end
end
