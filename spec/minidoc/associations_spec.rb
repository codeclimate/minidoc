require "spec_helper"

describe Minidoc::Associations do
  class Cat < Minidoc
    include Minidoc::Associations

    belongs_to :owner, class_name: "User"
  end

  class Doggie < Minidoc
    include Minidoc::Associations

    belongs_to :user
  end

  module Animal
    class Armadillo < Minidoc
      include Minidoc::Associations

      belongs_to :predator
    end

    class Predator < Minidoc
    end
  end

  describe "dynamically defined association methods" do
    it "can load associated documents" do
      expect(Cat.new.owner).to be_nil
      user = User.create
      cat = Cat.new(owner_id: user.id)
      expect(cat.owner.id).to eq user.id
      expect(cat.owner!.id).to eq user.id
      cat.save
      expect(cat.owner.id).to eq user.id
      expect(cat.owner!.id).to eq user.id
    end

    it "defines methods that raise when not found" do
      cat = Cat.new
      cat.owner_id = BSON::ObjectId.new
      expect { cat.owner! }.to raise_error(Minidoc::DocumentNotFoundError)
    end

    it "caches the association cache rather than go to the database each time" do
      user = User.create(name: "Bryan")
      cat = Cat.create(owner_id: user.id)
      expect(cat.owner.name).to eq "Bryan"
      user.set(name: "Noah")
      expect(cat.owner.name).to eq "Bryan"
      expect(cat.reload.owner.name).to eq "Noah"
    end

    it "expires the association cache when a new associated document is provided" do
      user = User.create(name: "Bryan")
      cat = Cat.create(owner_id: user.id)
      expect(cat.owner.name).to eq "Bryan"
      user.set(name: "Noah")
      expect(cat.owner.name).to eq "Bryan"
      cat.owner = user
      expect(cat.owner.name).to eq "Noah"
    end

    it "expires the association cache when the related foreign-key id field is updated" do
      user = User.create(name: "Bryan")
      cat = Cat.create(owner_id: user.id)
      expect(cat.owner.name).to eq "Bryan"
      user.set(name: "Noah")
      expect(cat.owner.name).to eq "Bryan"
      cat.owner_id = user.id
      expect(cat.owner.name).to eq "Noah"
    end
  end

  context "when the classes are not namespaced" do
    it "infers the class name of the association" do
      expect(Doggie.new.user).to be_nil
      user = User.create
      sam = Doggie.new(user_id: user.id)
      expect(sam.user.id).to eq user.id
      sam.save
      expect(sam.user.id).to eq user.id
    end
  end

  context "when the classes are namespaced" do
    it "infers the class name of the association" do
      expect(Animal::Armadillo.new.predator).to be_nil
      predator = Animal::Predator.create
      arnie = Animal::Armadillo.new(predator_id: predator.id)
      expect(arnie.predator.id).to eq predator.id
      arnie.save
      expect(arnie.predator.id).to eq predator.id
    end
  end
end
