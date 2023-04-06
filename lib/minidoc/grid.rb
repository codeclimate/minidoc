class Minidoc::Grid
  def initialize(database)
    @bucket = Mongo::Grid::FSBucket.new(database)
  end

  def put(str, filename = SecureRandom.uuid)
    bucket.upload_from_stream(filename, StringIO.new(str))
  end

  def get(id)
    id = BSON::ObjectId(id.to_s)
    io = StringIO.new
    bucket.download_to_stream(id, io)
    io.rewind
    io
  end

  def get_json(id)
    raw_data = get(id).read
    JSON.parse(raw_data)
  end

  def delete(id)
    id = BSON::ObjectId(id.to_s)
    bucket.delete(id)
  end

  private

  attr_reader :bucket
end
