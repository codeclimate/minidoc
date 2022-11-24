require "spec_helper"

describe Minidoc::Finders do
  describe ".all" do
    it "returns all of the documents in the collection" do
      User.collection.insert_one(name: "Joe")
      User.collection.insert_one(name: "Bryan")
      users = User.all
      expect(["Bryan", "Joe"]).to match_array(users.map(&:name))
    end
  end

  describe ".count" do
    it "counts the documents in the collection" do
      User.collection.insert_one(name: "Joe")
      User.collection.insert_one(name: "Bryan")
      expect(User.count).to eq 2
    end

    it "can be scoped by a query" do
      User.collection.insert_one(name: "Joe")
      User.collection.insert_one(name: "Bryan")
      expect(User.count(name: "Bryan")).to eq 1
    end
  end

  describe ".exists?" do
    it "tells you if any documents exist that match a query" do
      User.collection.insert_one(name: "Joe")
      expect(User.exists?(name: "Joe")).to be(true)
      expect(User.exists?(name: "Bryan")).to be(false)
    end
  end

  describe ".first" do
    it "returns a document from the collection" do
      expect(User.first).to be_nil
      user = User.create(name: "Bryan")
      expect(User.first.name).to eq "Bryan"
      expect(User.first).to eq user
    end
  end

  describe ".find" do
    it "querys the collection using the mongodb query language" do
      user = User.create(name: "Bryan")
      expect(User.find({}).to_a).to eq [user]
      expect(User.find(name: "Noah").to_a).to eq []
    end
  end

  describe ".find_one" do
    it "returns the first document that matches a query" do
      user = User.create(name: "Bryan")
      expect(User.find_one({})).to eq user
      expect(User.find_one).to eq user
      expect(User.find_one(name: "Noah")).to eq nil
    end
  end

  describe ".find_one!" do
    it "returns the first document that matches a query or raises an error" do
      expect { User.find_one! }.to raise_error(Minidoc::DocumentNotFoundError)
      user = User.create(name: "Bryan")
      expect(User.find_one!(name: "Bryan")).to eq user
      expect(User.find_one!).to eq user
      expect { User.find_one!(name: "Noah") }.to raise_error(Minidoc::DocumentNotFoundError)
    end
  end

  describe ".find_one_or_initialize" do
    it "returns the first document that matches a query or makes a non-persisted document from that query" do
      user = User.create(name: "Bryan", age: 1)
      expect((user == User.find_one_or_initialize(name: "Bryan"))).to be_truthy
      expect(User.find_one_or_initialize(name: "Noah").is_a?(User)).to eq true
      expect(User.find_one_or_initialize(name: "Noah").new_record?).to eq true
    end

    it "doesn't require attributes" do
      expect(User.find_one_or_initialize).to be_a User
      user = User.create(name: "Bryan", age: 1)
      expect(user).to eq User.find_one_or_initialize
    end

    it "allows query options" do
      user = User.create(name: "Noah", age: 1)
      expect((user == User.find_one_or_initialize({ age: 1 }, sort: { name: -1 }))).to be_truthy
      expect { User.find_one_or_initialize("foo") }.to raise_error(ArgumentError)
    end
  end
end
