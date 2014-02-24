require "active_support/concern"

module Minidoc::Indexes
  extend ActiveSupport::Concern

  module ClassMethods
    def ensure_index(*keys)
      options = keys.map { |key| { key => 1 } }.reduce(:merge)

      collection.ensure_index(options)
    end
  end
end
