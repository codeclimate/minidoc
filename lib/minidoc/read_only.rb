require "minidoc"

class Minidoc::ReadOnly
  include Connection
  include Finders
  include Virtus.model

  attribute :_id, BSON::ObjectId
  alias_method :id, :_id

  extend ActiveModel::Naming

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
