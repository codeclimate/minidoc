require "active_support/concern"

module Minidoc::Connection
  extend ActiveSupport::Concern

  included do
    class_attribute :connection
    class_attribute :database_name
  end

  module ClassMethods
    def collection
      database[collection_name]
    end

    def database
      connection[database_name]
    end

    def collection_name=(name)
      @collection_name = name
    end

    def collection_name
      @collection_name ||= name.demodulize.underscore.pluralize
    end
  end

  if ActiveSupport.respond_to?(:run_load_hooks)
    ActiveSupport.run_load_hooks(:mongo)
  end
end
