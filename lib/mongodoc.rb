require "mongo"
require "virtus"
require "active_model"
require "active_support/core_ext"

class MongoDoc
  VERSION = "0.0.1"

  if Virtus.respond_to?(:model)
    include Virtus.model
  else
    include Virtus
  end

  attribute :_id, BSON::ObjectId

  extend ActiveModel::Naming

  include ActiveModel::Conversion
  include ActiveModel::Validations

  # def self.collection
  #   # database[collection_name]
  # end

  # def self.database
  #   # connection[database_name]
  # end

  # def self.collection_name
  # end

  # def self.first
  # end

  # def self.count
  # end

  # def self.find_one
  # end

  # def self.distinct
  # end

  # def self.upsert
  # end

  # def self.find
  # end

  # def self.create
  # end

  # def self.create!
  # end

  # def self.delete
  # end

  # def self.set
  # end

  # def self.unset
  # end

  # def self.wrap
  # end

  def id
    _id
  end

  def id=(new_id)
    self._id = new_id
  end

  # def new_record?
  # end

  # def destroyed?
  # end

  def persisted?
    true
    # !(new_record? || destroyed?)
  end

  # def delete
  # end

  # def destroy
  # end

  # def reload
  # end

  # def save
  # end

  # def save!
  # end

  # def set
  # end

  # def unset
  # end

  # def to_param
  # end

  def to_key
    [id.to_s]
  end

  # def cache_key
  # end
end
