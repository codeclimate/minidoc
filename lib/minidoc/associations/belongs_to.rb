module Minidoc::Associations
  module BelongsTo
    module ClassMethods
      def belongs_to(association_name, options = {})
        association_name = association_name.to_sym
        associations[association_name] = options

        attribute "#{association_name}_id", BSON::ObjectId

        define_method("#{association_name}=") do |value|
          write_belongs_to_association(association_name, value)
        end

        define_method("#{association_name}_id=") do |value|
          instance_variable_set("@#{association_name}", nil)
          super(value)
        end

        define_method(association_name) do
          read_belongs_to_association(association_name)
        end
      end
    end

    module InstanceMethods
      def write_belongs_to_association(name, value)
        send("#{name}_id=", value ? value.id : nil)
      end
      private(:write_belongs_to_association)

      def read_belongs_to_association(name)
        return instance_variable_get("@#{name}") if instance_variable_get("@#{name}")

        options = self.class.associations[name]

        if (foreign_id = self["#{name}_id"])
          record = options[:class_name].constantize.find(foreign_id)
          instance_variable_set("@#{name}", record)
          record
        end
      end
      private(:read_belongs_to_association)
    end
  end
end
