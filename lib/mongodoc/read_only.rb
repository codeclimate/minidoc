require "mongodoc"

class MongoDoc::ReadOnly
  include Connection

  if Virtus.respond_to?(:model)
    include Virtus.model
  else
    include Virtus
  end

  attribute :_id, BSON::ObjectId

  extend ActiveModel::Naming

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

  def self.wrap(doc)
    return nil unless doc

    if doc.is_a?(Array) || doc.is_a?(Mongo::Cursor)
      doc.map { |d| new(d) }
    else
      new(doc)
    end
  end

  def id
    _id
  end

  def ==(other)
    other.class == self.class &&
    self.id &&
    other.id &&
    self.id == other.id
  end

  def to_key
    [id.to_s]
  end

  def to_param
    id.to_s
  end
end
