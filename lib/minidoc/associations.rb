require "active_support/concern"

module Minidoc::Associations
  extend ActiveSupport::Concern

  module ClassMethods
    def associations
      @associations ||= {}
    end

    def belongs_to(association_name, options = {})
      options[:class_name] ||= "#{self.parent.name}::#{association_name.to_s.camelize}"

      association_name = association_name.to_sym
      associations[association_name] = options

      attribute "#{association_name}_id", BSON::ObjectId

      define_method("#{association_name}=") do |value|
        write_association(association_name, value)
      end

      define_method("#{association_name}_id=") do |value|
        instance_variable_set("@#{association_name}", nil)
        super(value)
      end

      define_method(association_name) do
        read_association(association_name)
      end

      define_method("#{association_name}!") do
        read_association(association_name) or
          raise Minidoc::DocumentNotFoundError
      end
    end
  end

  def reload
    clear_association_caches
    super
  end

private

  def write_association(name, value)
    send("#{name}_id=", value ? value.id : nil)
  end

  def read_association(name)
    return instance_variable_get("@#{name}") if instance_variable_get("@#{name}")

    options = self.class.associations[name]

    if (foreign_id = self["#{name}_id"])
      record = options[:class_name].constantize.find(foreign_id)
      instance_variable_set("@#{name}", record)
      record
    end
  end

  def clear_association_caches
    self.class.associations.each do |name, options|
      instance_variable_set("@#{name}", nil)
    end
  end
end
