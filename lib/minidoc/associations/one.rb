module Minidoc::Associations
  module One
    module ClassMethods
      def one(association_name, options = {})
        add_association(association_name, options)

        define_method(association_name) do
          read_one_association(association_name)
        end
      end
    end

    module InstanceMethods
      def read_one_association(name)
        return instance_variable_get("@#{name}") if instance_variable_get("@#{name}")

        options = self.class.associations[name]

        if foreign_id = self.id
          foreign_id_key = options[:foreign_key]

          record = options[:class_name].constantize.find_one(foreign_id_key => foreign_id)
          instance_variable_set("@#{name}", record)
          record
        end
      end
      private(:read_one_association)
    end
  end
end

