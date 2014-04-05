class Minidoc::Grid < Mongo::Grid
  def get(id)
    id = BSON::ObjectId(id.to_s)
    super(id)
  end

  def get_json(id)
    raw_data = get(id).read
    JSON.parse(raw_data)
  end

  def delete(id)
    id = BSON::ObjectId(id.to_s)
    super(id)
  end
end
