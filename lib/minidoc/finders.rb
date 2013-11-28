require "active_support/concern"

module Minidoc::Finders
  extend ActiveSupport::Concern

  module ClassMethods
    def first
      find_one({})
    end

    def count(selector = {})
      collection.count(query: selector)
    end

    def find(id_or_selector, options = {})
      if id_or_selector.is_a?(Hash)
        wrap(collection.find(id_or_selector, options))
      else
        raise ArgumentError unless options.empty?
        id = BSON::ObjectId(id_or_selector.to_s)
        wrap(collection.find_one(_id: id))
      end
    end

    def find_one(selector, options = {})
      wrap(collection.find_one(selector, options))
    end

    def wrap(doc)
      return nil unless doc

      if doc.is_a?(Array) || doc.is_a?(Mongo::Cursor)
        doc.map { |d| new(d) }
      else
        new(doc)
      end
    end
  end
end
