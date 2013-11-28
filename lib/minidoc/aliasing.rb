require "active_support/concern"

module Minidoc::Aliasing
  extend ActiveSupport::Concern

  module ClassMethods
    def short_attribute(short_name, long_name)
      attr = attribute_set[long_name].rename(short_name)
      attribute_set[long_name] = attr
      attribute_set.reset
      attr.define_accessor_methods(attribute_set)

      module_eval <<-STR, __FILE__, __LINE__ + 1
        def #{short_name}
          @#{short_name} || @#{long_name}
        end

        def #{long_name}=(value)
          @#{long_name} = value
        end

        def #{long_name}
          @#{short_name} || @#{long_name}
        end
      STR
    end
  end
end
