require "active_support/concern"

module MongoDoc::Timestamps
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
