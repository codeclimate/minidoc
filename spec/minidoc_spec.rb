require "spec_helper"

describe Minidoc do
  class ValidationsUser < User
    validates :name, presence: true
  end

  describe "#model_name" do
    it "returns the name of the class" do
      expect(User.model_name.to_s).to eq "User"
    end
  end

  describe "#to_model" do
    it "returns itself" do
      user = User.new
      expect(user.to_model).to eq user
    end
  end

  describe "#to_key" do
    it "returns an array of key attributes" do
      user = User.new
      user.id = BSON::ObjectId("52955618f9f6a52444000001")
      expect(user.to_key).to eq ["52955618f9f6a52444000001"]
    end
  end

  describe "#to_param" do
    it "returns a string suitable for use in URLs" do
      user = User.new
      user.id = BSON::ObjectId("52955618f9f6a52444000001")
      expect(user.to_param).to eq "52955618f9f6a52444000001"
    end
  end

  describe "#to_partial_path" do
    it "returns a string which ActionPack could use to look up a partial template" do
      expect(User.new.to_partial_path).to eq "users/user"
    end
  end

  describe ".rescue_duplicate_key_errors" do
    it "returns the value of the block when there are no errors" do
      user = User.create!
      result = Minidoc.rescue_duplicate_key_errors { User.create!(name: "two") }
      expect(result.name).to eq "two"
    end

    it "returns false when a duplicate key error occurs" do
      user = User.create!
      result = Minidoc.rescue_duplicate_key_errors do
        User.create!(:_id => user.id, name: "two")
      end
      expect(result).to eq false
    end
  end

  describe ".new" do
    it "sets ids before the document is persisted" do
      user = User.new
      expect(user.id).to be_a BSON::ObjectId
    end

    it "allows you to provide an id" do
      user = User.new(:_id => BSON::ObjectId("52955cc5f9f6a538a9000001"))
      expect(user.id).to eq BSON::ObjectId("52955cc5f9f6a538a9000001")
    end
  end

  describe "#new_record?" do
    it "tells you whether the document has been persisted to the database or not" do
      user = User.new
      expect(user.new_record?).to eq true
      user.save
      expect(user.new_record?).to eq false
    end
  end

  describe "#save" do
    it "persists the document" do
      expect {
        user = User.new
        user.save
      }.to change { User.count }.from(0).to(1)
    end

    it "doesn't change id when persisted" do
      user = User.new
      expect {
        user.save
      }.to_not change { user.id }
    end

    it "raises Minidoc::DuplicateKey where appropriate" do
      collection = double
      expect(User).to receive(:collection).and_return(collection)
      expect(collection).to receive(:insert_one).and_raise(Mongo::Error::OperationFailure.new("Booooo (11000)"))
      user = User.new

      expect { user.save }.to raise_error(Minidoc::DuplicateKey)
    end

    it "doesn't suppress errors it shouldn't" do
      collection = double
      expect(User).to receive(:collection).and_return(collection)
      expect(collection).to receive(:insert_one).and_raise(ArgumentError)
      user = User.new

      expect { user.save }.to raise_error(ArgumentError)
    end

    it "persists changes to the database" do
      user = User.create(name: "Bryan")
      expect(user.persisted?).to be true

      user.name = "Noah"
      expect(user.name).to eq "Noah"
      user.save

      expect(user.reload.name).to eq "Noah"
    end

    it "doesn't persist changes when the validations aren't satisfied" do
      user = ValidationsUser.new
      expect(user.save).to be false
      expect(user.new_record?).to be true
      expect(user.errors[:name]).to eq ["can't be blank"]
    end

    it "isn't thrown off when two classes are backed by the same collection" do
      user = User.create(name: "Bryan", age: 20)
      user.name = "Noah"
      expect(user.name).to eq "Noah"
      user.save
      user.reload
      expect(user.name).to eq "Noah"
      expect(user.age).to eq 20

      second_user = SecondUser.find_one(age: 20)
      expect(user.id).to eq second_user.id
      second_user.age = 21
      expect(second_user.age).to eq 21
      second_user.save
      expect(second_user.reload.age).to eq 21

      user.reload
      expect(user.name).to eq "Noah"
      expect(user.age).to eq 21
    end
  end

  describe "#save!" do
    it "persists the change to the database" do
      user = User.create!(name: "Bryan")
      user.name = "Noah"
      user.save!

      expect(user.reload.name).to eq "Noah"
    end

    it "does not persist the change to the database when a validation is not satisfied" do
      expect {
        ValidationsUser.new.save!
      }.to raise_error(Minidoc::RecordInvalid)
    end
  end

  describe "#valid?" do
    it "checks that that validations are satisfied" do
      user = ValidationsUser.new
      expect(user).to_not be_valid

      user.name = "Noah"
      expect(user).to be_valid
    end
  end

  describe "#persisted?" do
    let(:user) { User.new }

    it "knows new records are not persisted" do
      expect(user.persisted?).to eq false
    end

    it "knows saved records are persisted" do
      user.save
      expect(user.persisted?).to eq true
    end

    it "knows deleted records are not persisted" do
      user.save!
      user.destroy
      expect(user.persisted?).to eq false
    end
  end

  describe ".create!" do
    it "inserts a document into the database" do
      user = User.create!(name: "Bryan")
      expect(user.name).to eq "Bryan"
      expect(user.persisted?).to be true
      expect(User.count).to eq 1
    end

    it "raises an error when a validation is not satisfied" do
      expect { ValidationsUser.create! }.to raise_error(Minidoc::RecordInvalid)
      expect(User.count).to eq 0
    end
  end

  describe ".create" do
    it "inserts a document into the database" do
      user = User.create(name: "Bryan")
      expect(user.name).to eq "Bryan"
      expect(User.count).to eq 1
    end

    it "does not insert a document when a validation is not satisfied" do
      user = ValidationsUser.create
      expect(user.persisted?).to be false
      expect(ValidationsUser.count).to eq 0
    end
  end

  describe "#destroy, #destroyed?" do
    it "removes the document from the collection, and the document knows it" do
      user = User.create!(name: "Bryan")
      expect(user.destroyed?).to eq false

      user.destroy

      expect(User.count).to eq 0
      expect(user.destroyed?).to eq true
    end
  end

  describe ".delete" do
    it "removes a document by id" do
      user = User.create!(name: "Bryan")

      User.delete(user.id)

      expect(User.count).to eq 0

      expect { user.reload }.to raise_error(Minidoc::DocumentNotFoundError)
    end
  end

  describe "#delete" do
    it "removes itself from the collection" do
      user = User.create!(name: "Bryan")
      user.delete
      expect(User.count).to eq 0
    end
  end

  describe "#reload" do
    it "refreshes the object with any changed data from the underlying database" do
      user = User.create!(name: "Bryan")
      expect(user.reload.name).to eq "Bryan"

      User.collection.update_one({ :_id => user.id }, name: "Noah")
      expect(user.name).to eq "Bryan"

      user.reload
      expect(user.name).to eq "Noah"
    end
  end

  describe ".set" do
    it "sets a field on a document with a provided id" do
      user = User.create!(name: "Bryan")
      User.set(user.id, name: "Noah")
      expect(user.name).to eq "Bryan"
      expect(user.reload.name).to eq "Noah"
    end

    it "allows passing an id as a string rather than a BSON::ObjectId" do
      user = User.create!(name: "Noah")
      User.set(user.id.to_s, name: "Mike")
      expect(user.reload.name).to eq "Mike"
      expect(User.first.name).to eq "Mike"
    end
  end

  describe "#set" do
    it "changes the field (without needing to call save)" do
      user = User.create!(name: "Bryan")
      user.set(name: "Noah")
      expect(user.name).to eq "Noah"
      expect(user.reload.name).to eq "Noah"
      expect(User.first.name).to eq "Noah"
    end

    it "allows changing the field, referenced as a string" do
      user = User.create(name: "Bryan")
      user.set("name" => "Noah")
      expect(user.name).to eq "Noah"
      expect(user.reload.name).to eq "Noah"
      expect(User.first.name).to eq "Noah"
    end

    it "bypasses validations, so be careful" do
      user = ValidationsUser.create!(name: "Bryan")
      expect(user).to be_valid

      user.set(name: nil)
      user.reload

      expect(user).to_not be_valid
    end
  end

  describe ".unset" do
    it "allows removing a field for a document with the provided id" do
      user = User.create!(name: "Bryan")
      User.unset(user.id, :name)
      expect(user.name).to eq "Bryan"
      expect(user.reload.name).to eq nil
      expect(User.first.name).to eq nil
    end

    it "doesn't mind if the provided id is a string rather than a BSON::ObjectId" do
      user = User.create!(name: "Bryan")
      User.unset(user.id.to_s, :name)
      expect(user.reload.name).to eq nil
      expect(User.first.name).to eq nil
    end
  end

  describe "#unset" do
    it "removes a field for a document" do
      user = User.create!(name: "Bryan")
      user.unset(:name)
      expect(user.name).to eq nil
      expect(user.reload.name).to eq nil
      expect(User.first.name).to eq nil
    end

    it "doesn't mind if you reference the field as a string" do
      user = User.create!(name: "Bryan")
      user.unset("name")
      expect(user.name).to eq nil
      expect(user.reload.name).to eq nil
    end
  end

  describe "#atomic_set" do
    it "updates the document (and not others) as long as the provided query is satisfied" do
      user = User.create!(name: "from", age: 18)
      other_user = User.create!(name: "from", age: 21)

      expect(user.atomic_set({ name: "from" }, name: "to")).to be_truthy

      expect(user.name).to eq "to"
      expect(user.age).to eq 18
      user.reload
      expect(user.name).to eq "to"
      expect(user.age).to eq 18

      other_user.reload
      expect(other_user.name).to eq "from"
      expect(other_user.age).to eq 21
    end

    it "does not update the document when the provided query is not satisfied" do
      user = User.create!(name: "from", age: 18)

      expect(user.atomic_set({ name: "not-from" }, name: "to")).to be_falsey

      expect(user.name).to eq "from"
      expect(user.age).to eq 18
      user.reload
      expect(user.name).to eq "from"
      expect(user.age).to eq 18
    end
  end
end
