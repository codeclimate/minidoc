require "active_support/concern"

module Minidoc::Indexes
  extend ActiveSupport::Concern

  module ClassMethods
    def ensure_index(key_or_keys, options = {})
      indexes = Array(key_or_keys).map { |key| { key => 1 } }.reduce(:merge)

      collection.ensure_index(indexes, options)
    end
  end
end
