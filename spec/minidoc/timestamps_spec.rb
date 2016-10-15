require "spec_helper"

describe Minidoc::Timestamps do
  class TimestampsUser < Minidoc
    include Minidoc::Timestamps

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
  end
end
