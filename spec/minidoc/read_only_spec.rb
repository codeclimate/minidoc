require "spec_helper"

describe Minidoc::ReadOnly do
  class ReadOnlyUser < Minidoc::ReadOnly
    self.collection_name = "users"
    self.database_name = "minidoc_test"
    self.connection = $mongo

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

  it "can become a value object" do
    user = User.new(name: "Bryan")
    user.name = "Noah"
    user = user.as_value

    expect { user.name = "Noah" }.to raise_error(NoMethodError)
  end
end
