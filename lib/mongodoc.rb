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

  class RecordInvalid < StandardError
    attr_reader :record

    def initialize(record)
      @record = record
      errors = @record.errors.full_messages.join(", ")
      super("Record invalid: #{errors}")
    end
  end

  class_attribute :connection
  class_attribute :database_name

  def self.collection
    database[collection_name]
  end

  def self.database
    connection[database_name]
  end

  class << self
    attr_writer :collection_name
  end

  def self.collection_name
    return @collection_name if @collection_name
    @collection_name = name.demodulize.underscore.pluralize
  end

  class_attribute :record_timestamps

  def self.timestamps!
    self.record_timestamps = true
    attribute :created_at, Time
    attribute :updated_at, Time
  end

  def self.first
    find_one({})
  end

  def self.count(selector = {})
    collection.count(query: selector)
  end

  def self.find(id_or_selector, options = {})
    if id_or_selector.is_a?(Hash)
      wrap(collection.find(id_or_selector, options))
    else
      raise ArgumentError unless options.empty?
      id = BSON::ObjectId(id_or_selector.to_s)
      wrap(collection.find_one(_id: id))
    end
  end

  def self.find_one(selector, options = {})
    wrap(collection.find_one(selector, options))
  end

  def self.create(attrs = {})
    new(attrs).tap(&:save)
  end

  def self.create!(*args)
    new(*args).save!
  end

  def self.delete(id)
    collection.remove(_id: BSON::ObjectId(id.to_s))
  end

  def self.set(id, attributes)
    id = BSON::ObjectId(id.to_s)
    collection.update({ "_id" => id }, "$set" => attributes)
  end

  def self.unset(id, *keys)
    id = BSON::ObjectId(id.to_s)

    unsets = {}
    keys.each do |key|
      unsets[key] = 1
    end

    collection.update({ "_id" => id }, "$unset" => unsets)
  end

  def self.wrap(doc)
    return nil unless doc

    if doc.is_a?(Array) || doc.is_a?(Mongo::Cursor)
      doc.map { |d| new(d) }
    else
      new(doc)
    end
  end

  def self.associations
    @associations ||= {}
  end

  def self.belongs_to(association_name, options = {})
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

  def ==(other)
    other.class == self.class &&
    self.id &&
    other.id &&
    self.id == other.id
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
    clear_association_caches

    new_object = self.class.find(self.id)

    self.class.attribute_set.each do |attr|
      self[attr.name] = new_object[attr.name]
    end

    self
  end

  def save
    valid? ? create_or_update : false
  end

  def save!
    valid? ? create_or_update : raise(RecordInvalid.new(self))
  end

  def set(attributes)
    self.class.set(id, attributes)

    attributes.each do |name, value|
      self[name] = value
    end
  end

  def unset(*keys)
    self.class.unset(id, *keys)

    keys.each do |key|
      self[key] = nil
    end
  end

  def to_key
    [id.to_s]
  end

  def to_param
    id.to_s
  end

private

  def create_or_update
    new_record? ? create : update
    @new_record = false
    true
  end

  def create
    if self.class.record_timestamps
      current_time = Time.now.utc
      self.created_at = current_time
      self.updated_at = current_time
    end

    self.class.collection << attributes
  end

  def update
    if self.class.record_timestamps
      self.updated_at = Time.now.utc
    end

    self.class.collection.update({ _id: id }, attributes)
  end

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
