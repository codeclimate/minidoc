# encoding: utf-8
require "spec_helper"

describe "connection" do
  class Company < Minidoc
    self.collection_name = "accounts"
  end

  describe ".collection_name" do
    it "is inferred based on the class name" do
      expect(User.collection_name).to eq "users"
    end

    it "can be overridden" do
      expect(Company.collection_name).to eq "accounts"
    end
  end

  describe ".collection" do
    it "exposes the underlying Mongo object" do
      expect(User.collection).to be_a Mongo::Collection
    end

    it "passes through the collection_name to the underlying Mongo::Collection" do
      expect(User.collection.name).to eq "users"
      expect(Company.collection.name).to eq "accounts"
    end
  end

  describe ".database" do
    it "exposes the underlying Mongo object" do
      expect(User.database).to be_a Mongo::Database
    end

    it "passes through the database name to the underlying Mongo::DB" do
      expect(User.database.name).to eq "minidoc_test"
    end
  end

  describe "first run experience" do
    it "fails helpfully if you haven't configured the necessary values" do
      with_alternative_configuration do
        Minidoc.connection = nil
        Minidoc.database_name = nil
        expect { User.create(name: "Kären") }.to raise_error(Minidoc::MissingConfiguration, "Make sure to set Minidoc.connection")
      end
    end

    it "fails helpfully if you've only neglected the database_name" do
      with_alternative_configuration do
        Minidoc.database_name = nil
        expect { User.create(name: "Kären") }.to raise_error(Minidoc::MissingConfiguration, "Make sure to set Minidoc.database_name")
      end
    end
  end

  def with_alternative_configuration
    original_connection = Minidoc.connection
    original_database_name = Minidoc.database_name
    yield
  ensure
    Minidoc.connection = original_connection
    Minidoc.database_name = original_database_name
  end
end
