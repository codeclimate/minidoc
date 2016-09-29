require "active_support/concern"

module Minidoc::Connection
  extend ActiveSupport::Concern

  included do
    class_attribute :connection
    class_attribute :database_name
  end

  MissingConfiguration = Class.new(StandardError)

  module ClassMethods
    def collection
      database[collection_name]
    end

    def database
      validate_config
      connection[database_name]
    end

    def collection_name=(name)
      @collection_name = name
    end

    def collection_name
      @collection_name ||= name.demodulize.underscore.pluralize
    end

    private

    def validate_config
      if connection.nil?
        raise MissingConfiguration, "Make sure to set Minidoc.connection"
      elsif database_name.nil?
        raise MissingConfiguration, "Make sure to set Minidoc.database_name"
      end
    end
  end
end
