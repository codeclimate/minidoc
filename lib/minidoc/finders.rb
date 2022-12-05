require "active_support/concern"
require "forwardable"

module Minidoc::Finders
  extend ActiveSupport::Concern

  DocumentNotFoundError = Class.new(StandardError)

  module ClassMethods
    def all
      find({})
    end

    def first
      find_one({})
    end

    def count(selector = {})
      collection.count_documents(selector)
    end

    def exists?(selector = {})
      find_one(selector).present?
    end

    def find(id_or_selector, options = {})
      if id_or_selector.is_a?(Hash)
        ResultSet.new(collection.find(id_or_selector, options), wrapper)
      else
        raise ArgumentError unless options.empty?
        id = BSON::ObjectId(id_or_selector.to_s)
        wrapper.call(collection.find(_id: id).first)
      end
    end

    def find_one(selector = {}, options = {})
      # running collection.find({}).first will leave the cursor open unless we iterate across all of the documents
      # so in order to do not let a cusror open we want to kill the cursor after having grabbed the first document
      view = collection.find(selector, options)
      wrapped_doc = wrapper.call(view.first)
      view.close_query
      wrapped_doc
    end

    def find_one!(selector = {}, options = {})
      find_one(selector, options) or raise DocumentNotFoundError
    end

    def find_one_or_initialize(attributes = {}, options = {})
      raise ArgumentError unless attributes.is_a?(Hash)
      find_one(attributes, options) || new(attributes)
    end

    private

    def from_db(attrs)
      doc = new(attrs)
      doc.instance_variable_set("@new_record", false)
      doc
    end

    def wrapper
      @wrapper ||= Proc.new do |doc|
        if doc
          if doc.is_a?(Array) || doc.is_a?(Mongo::Cursor)
            doc.map { |d| from_db(d) }
          else
            from_db(doc)
          end
        else
          nil
        end
      end
    end
  end

  class ResultSet
    extend Forwardable
    include Enumerable

    def initialize(view, doc_wrapper)
      @view = view
      @doc_wrapper = doc_wrapper
    end

    def each(&block)
      if block_given?
        @view.each do |doc|
          yield  @doc_wrapper.call(doc)
        end
      else
       to_enum
      end
    end

    def count
      @view.count_documents
    end
  end
end
