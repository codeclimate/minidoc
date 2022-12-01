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
        view.each do |doc|
          yield  transformer.call(doc)
        end if block_given?

        # this should be an Enumerator object to follow ruby conventions
        transformed_view
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
      find({}).to_a
    end

    def first
      find_one({})
    end

    def count(selector = {})
      collection.count(selector)
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
      wrap(collection.find(selector, options).first)
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
