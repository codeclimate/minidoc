require "active_support/concern"
require "minidoc/associations/belongs_to"
require "minidoc/associations/many"

module Minidoc::Associations
  extend ActiveSupport::Concern
  include Minidoc::Associations::BelongsTo::InstanceMethods
  include Minidoc::Associations::Many::InstanceMethods

  module ClassMethods
    include Minidoc::Associations::BelongsTo::ClassMethods
    include Minidoc::Associations::Many::ClassMethods

    def associations
      @associations ||= {}
    end

    def add_association(name, options = {})
      associations[name.to_sym] = options
    end
  end

  def reload
    clear_association_caches
    super
  end

private

  def clear_association_caches
    self.class.associations.each do |name, options|
      instance_variable_set("@#{name}", nil)
    end
  end
end

