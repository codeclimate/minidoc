require "active_support/concern"

module Minidoc::Timestamps
  extend ActiveSupport::Concern

  included do
    class_attribute :record_timestamps
  end

  module ClassMethods
    def timestamps!
      self.record_timestamps = true
      attribute :created_at, Time
      attribute :updated_at, Time
    end
  end

  def set(attributes)
    if self.class.record_timestamps
      super(attributes.merge(updated_at: Time.now.utc))
    else
      super(attributes)
    end
  end

  def atomic_set(query, attributes)
    if self.class.record_timestamps
      super(query, attributes.merge(updated_at: Time.now.utc))
    else
      super(query, attributes)
    end
  end

  def unset(*keys)
    super

    set(updated_at: Time.now.utc) if self.class.record_timestamps
  end

private

  def create
    if self.class.record_timestamps
      current_time = Time.now.utc
      self.created_at = current_time
      self.updated_at = current_time
    end

    super
  end

  def update
    if self.class.record_timestamps
      self.updated_at = Time.now.utc
    end

    super
  end
end
