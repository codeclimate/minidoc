require "spec_helper"

describe Minidoc::ReadOnly do
  class ReadOnlyUser < Minidoc::ReadOnly
    self.collection_name = "users"
    self.database_name = "minidoc_test"
    self.connection = $mongo

    attribute :name, String
  end

  class AltModel < Minidoc::ReadOnly
    self.connection = $alt_mongo
    self.database_name = $alt_mongo.db.name

    attribute :name, String
  end

  it "is read only, meaning it can't change over time" do
    expect { ReadOnlyUser.create(name: "Bryan") }.to raise_error(NoMethodError)

    rw_user = User.create(name: "Bryan")
    user = ReadOnlyUser.first
    expect(user.name).to eq "Bryan"
    expect(rw_user.id).to eq user.id
    expect(user).to eq user.as_value

    expect { user.name = "Noah" }.to raise_error(NoMethodError)
  end

  it "can have a separate mongo connection" do
    expect(AltModel.count).to eq(0)
    $alt_mongo.db[:alt_models].insert(name: "42")
    expect(AltModel.count).to eq(1)

    instance = AltModel.find_one(name: "42")
    expect(instance.name).to eq("42")

    expect { instance.name = "Noah" }.to raise_error(NoMethodError)
  end

  it "can become a value object" do
    user = User.new(name: "Bryan")
    user.name = "Noah"
    user = user.as_value

    expect { user.name = "Noah" }.to raise_error(NoMethodError)
  end
end
