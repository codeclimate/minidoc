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

  class_attribute :connection
  class_attribute :database_name

  def self.collection
    database[collection_name]
  end

  def self.database
    connection[database_name]
  end

  def self.collection_name
    name.demodulize.underscore.pluralize
  end

  # def self.first
  # end

  def self.count(selector = {})
    collection.count(query: selector)
  end

  # def self.distinct
  # end

  # def self.upsert
  # end

  def self.find(id_or_selector) #, options = {})
    # if id_or_selector.is_a?(Hash)
    #   collection.find(id_or_selector, options).map do |doc|
    #     wrap(doc)
    #   end
    # else
      # raise ArgumentError unless options.empty?
      id = BSON::ObjectId(id_or_selector.to_s)
      wrap(collection.find_one(_id: id))
    # end
  end

  def self.find_one(selector, options = {})
    wrap(collection.find_one(selector, options))
  end

  def self.create(attrs = {})
    record = new(attrs)
    record.save
    record
  end

  # def self.create!
  # end

  def self.delete(id)
    collection.remove(_id: BSON::ObjectId(id.to_s))
  end

  # def self.set
  # end

  # def self.unset
  # end

  def self.wrap(doc)
    return nil unless doc

    if doc.is_a?(Array)
      doc.map { |d| new(d) }
    else
      new(doc)
    end
  end

  def initialize(attrs = {})
    if attrs["_id"].nil? && attrs[:_id].nil?
      attrs[:_id] = BSON::ObjectId.new
    end

    @new_record = true
    @destroyed = false

    super(attrs)
  end

  def id
    _id
  end

  def id=(new_id)
    self._id = new_id
  end

  def new_record?
    @new_record
  end

  def destroyed?
    @destroyed
  end

  def persisted?
    !(new_record? || destroyed?)
  end

  def delete
    self.class.delete(id)
  end

  def destroy
    delete
    @destroyed = true
  end

  def reload
    new_object = self.class.find(self.id)

    self.class.attribute_set.each do |attr|
      self[attr.name] = new_object[attr.name]
    end

    self
  end

  def save
    self.class.collection << attributes
    @new_record = false
    true
  end

  # def save!
  # end

  # def set
  # end

  # def unset
  # end

  def to_key
    [id.to_s]
  end

  def to_param
    id.to_s
  end
end
