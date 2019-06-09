$ gem install minidoc

Minidoc.connection = Mongo::MongoClient.from_uri("mongodb://localhost")
Minidoc.database_name = "my_great_app_development"

class User < Minidoc
  include Minidoc::Timestamps

  attribute :name, String
  attribute :language, String
  timestamps!
end

user = User.create!(name: "Bryan", language: "Cobol")
User.count # => 1

user.language = "Lisp"
user.save!

user.set(language: "Fortran")

user.destroy
User.count # => 0

class User < Minidoc
  attribute :name, String

  validates :name, presence: true
end

user = User.new
user.valid? # => false
user.name = "Bryan"
user.valid? # => true


class DrinkEvents < Minidoc::ReadOnly
  include Minidoc::Timestamps
  timestamps!
end

DrinkEvents.count(created_at: { "$gt": 4.days.ago }) #=> 0
DrinkEvents.create #=> NoMethodError
bryan = User.create(name: "Bryan").as_value
bryan.name #=> "Bryan"
bryan.name = "Brian" #=> NoMethodError

class Drink < Minidoc
  include Minidoc::Associations

  attribute :name, String

  belongs_to :user
end

bryan = User.create(name: "Bryan")
drink = Drink.create(name: "Paloma", user: bryan)
drink.user == bryan #=> true

user.destroy
Drink.find(name: "Paloma").user!
# => Minidoc::DocumentNotFoundError
