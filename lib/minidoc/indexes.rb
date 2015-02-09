require "active_support/concern"

module Minidoc::Indexes
  extend ActiveSupport::Concern

  module ClassMethods
    MONGO_DUPLICATE_KEY_ERROR_CODE = 11000

    def ensure_index(key_or_keys, options = {})
      indexes = Array(key_or_keys).map { |key| { key => 1 } }.reduce(:merge)

      collection.ensure_index(indexes, options)
    end

    # Rescue a <tt>Mongo::OperationFailure</tt> exception which originated from
    # duplicate key error (error code 11000) in the given block.
    #
    # Returns the status of the operation in the given block, or +false+ if the
    # exception was raised.
    def rescue_duplicate_key_errors
      yield
    rescue Mongo::OperationFailure => exception
      if exception.respond_to?(:error_code) &&
        exception.error_code == MONGO_DUPLICATE_KEY_ERROR_CODE
        return false
      else
        raise
      end
    end
  end
end
