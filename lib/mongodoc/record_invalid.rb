class MongoDoc::RecordInvalid < StandardError
  attr_reader :record

  def initialize(record)
    @record = record
    errors = @record.errors.full_messages.join(", ")
    super("Record invalid: #{errors}")
  end
end
