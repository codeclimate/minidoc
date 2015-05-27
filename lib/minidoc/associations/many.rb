module Minidoc::Associations
  module Many
    module ClassMethods
      def many(association_name, options = {})
        add_association(association_name, options)

        define_method(association_name) do
          read_many_association(association_name)
        end
      end
      alias_method :has_many, :many
    end

    module InstanceMethods
      def read_many_association(name)
        return instance_variable_get("@#{name}") if instance_variable_get("@#{name}")

        options = self.class.associations[name]

        if foreign_id = self.id
          foreign_id_key = options[:foreign_key]

          record = options[:class_name].constantize.find(foreign_id_key => foreign_id)
          instance_variable_set("@#{name}", record)
          record
        end
      end
      private(:read_many_association)
    end
  end
end
