require "minidoc"

class Minidoc::ReadOnly
  include Minidoc::Connection
  include Minidoc::Finders
  include Virtus::ValueObject

  def self.database
    Minidoc.database
  end

  attribute :_id, BSON::ObjectId
  alias_method :id, :_id

  extend ActiveModel::Naming

  def ==(other)
    other.is_a?(self.class) && self.id && self.id == other.id
  end

  def to_key
    [id.to_s]
  end

  def to_param
    id.to_s
  end
end
