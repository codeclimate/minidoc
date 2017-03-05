require "spec_helper"

describe Minidoc::Grid do
  let(:grid) { Minidoc::Grid.new(Minidoc.database) }

  describe "#put and #get" do
    it "can store raw string data" do
      doc_id = grid.put "estamos en espana"
      expect(doc_id).to be_a BSON::ObjectId

      document = grid.get doc_id.to_s

      expect(document.read).to eq "estamos en espana"
    end
  end

  describe "#get_json" do
    it "parses the JSON into structured ruby objects" do
      hash = { "foo" => { "bar" => 1 } }
      doc_id = grid.put(hash.to_json)

      value = grid.get_json(doc_id.to_s)

      expect(value).to eq hash
    end
  end

  describe "#delete" do
    it "removes the 'file' from the database" do
      doc_id = grid.put "estamos en espana"

      expect(grid.get(doc_id).read).to eq("estamos en espana")
      grid.delete doc_id.to_s
      expect { grid.get(doc_id) }.to raise_error(Mongo::Error::FileNotFound)
    end
  end
end
