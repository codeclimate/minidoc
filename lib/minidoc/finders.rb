require "active_support/concern"
require "forwardable"

module Minidoc::Finders
  extend ActiveSupport::Concern

  DocumentNotFoundError = Class.new(StandardError)

  module ClassMethods
    class ViewWrapper
      extend Forwardable

      def initialize(view, transformer)
        @view = view
        @transformer = transformer
      end

      def_delegators :transformed_view, :to_a, :map, :include?, :flat_map, :compact, :[], :select, :group_by,
        :any?, :first, :sort_by

      def each(&block)
        # this method should always return an Enumerator object  to follow ruby conventions
        # but that would be expensive so I'd prefer not to
        if block_given?
          view.each do |doc|
            yield  transformer.call(doc)
          end
        else
          transformed_view.to_enum
        end
      end

      # I don't want to transform all of the documents and then grab the first one
      def first
        transformer.call(view.first)
      end

      private

      attr_reader :view, :transformer

      def transformed_view
        @transformed_view ||= view.map(&transformer)
      end

      def method_missing(method_name, *args)
        view.send(method_name, *args)
      end
    end

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
        ViewWrapper.new(collection.find(id_or_selector, options), transformer)
      else
        raise ArgumentError unless options.empty?
        id = BSON::ObjectId(id_or_selector.to_s)
        wrap(collection.find(_id: id).first)
      end
    end

    def find_one(selector = {}, options = {})
      # running collection.find({}).first will leave the cursor open unless we iterate across all of the documents
      # so in order to do not let a cusror open we want to kill the cursor after having grabbed the first document
      view = collection.find(selector, options)
      wrapped_doc = wrap(view.first)
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

    def transformer
      @transformer ||= Proc.new do |doc|
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

    def wrap(doc)
      transformer.call(doc)
    end
  end
end
