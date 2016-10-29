require "spec_helper"

describe Minidoc::Timestamps do
  class TimestampsUser < Minidoc
    include Minidoc::Timestamps

    attribute :name, String

    timestamps!
  end

  describe ".timestamps!" do
    it "automatically sets created_at and updated_at" do
      user = TimestampsUser.create!
      expect(user.created_at).to_not be_nil
      expect(user.created_at).to eq user.updated_at
    end

    it "updates the updated_at when the document changes" do
      user = TimestampsUser.create
      sleep 0.001
      user.save
      expect(user.created_at).to_not eq user.updated_at
    end

    it "updates updated_at when doc is changed with #set" do
      user = TimestampsUser.create
      sleep 0.001
      user.set(name: "Abby Normal")
      expect(user.created_at).to_not eq user.updated_at
    end

    it "updates updated_at when doc is changed with #atomic_set" do
      user = TimestampsUser.create
      sleep 0.001
      user.atomic_set({ name: nil }, name: "Abby Normal")
      expect(user.created_at).to_not eq user.updated_at
    end

    it "updates updated_at when doc is changed with #unset" do
      user = TimestampsUser.create(name: "Abby Normal")
      sleep 0.001
      user.unset(:name)
      expect(user.name).to be_nil
      expect(user.created_at).to_not eq user.updated_at
    end
  end
end
