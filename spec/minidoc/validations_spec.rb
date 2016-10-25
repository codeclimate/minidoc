require "spec_helper"

describe Minidoc::Validations do
  describe Minidoc::Validations::UniquenessValidator do
    class UniquenessUser < User
      validates :name, uniqueness: true
    end

    class InsensitiveUser < User
      attribute :insensitive, String
      validates :insensitive, uniqueness: { case_sensitive: false }
    end

    class ScopedUser < User
      attribute :country_id, Integer
      attribute :tax_id_number, Integer
      validates :tax_id_number, uniqueness: { scope: :country_id }
    end

    it "is invalid with existing value" do
      UniquenessUser.create!(name: "same name")
      user = UniquenessUser.new(name: "same name")
      expect(user).to_not be_valid
      expect(user.errors[:name]).to eq ["has already been taken"]
    end

    it "is case insensitive by default" do
      UniquenessUser.create!(name: "different case")
      user = UniquenessUser.new(name: "DIFFERENT CASE")
      expect(user).to be_valid
    end

    it "persists a document that passes validations" do
      user = UniquenessUser.create!(name: "lonely")
      expect(user).to be_valid
    end

    it "can be made case insensitive" do
      InsensitiveUser.create!(insensitive: "equivalent")
      user = InsensitiveUser.new(insensitive: "EquivALENT")
      expect(user).to_not be_valid
      expect(user.errors["insensitive"]).to eq ["has already been taken"]
    end

    it "does not allow the same value within a scope" do
      ScopedUser.create!(country_id: 1, tax_id_number: 1)
      user = ScopedUser.new(country_id: 1, tax_id_number: 1)
      expect(user).to_not be_valid
      expect(user.errors[:tax_id_number]).to eq ["has already been taken"]
    end

    it "allows a different value within the same scope" do
      ScopedUser.create!(country_id: 1, tax_id_number: 1)
      user = ScopedUser.new(country_id: 1, tax_id_number: 2)
      expect(user).to be_valid
    end

    it "does allow the same value in a different scope" do
      ScopedUser.create!(country_id: 1, tax_id_number: 1)
      user = ScopedUser.new(country_id: 2, tax_id_number: 1)
      expect(user).to be_valid
    end
  end
end
