require "minidoc"

class Minidoc::Value
  include Virtus.value_object
  extend ActiveModel::Naming

  attribute :_id, BSON::ObjectId
  alias_method :id, :_id

  def to_key
    [id.to_s]
  end

  def to_param
    id.to_s
  end

  def as_value
    self
  end
end
