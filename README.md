[![Build Status](https://travis-ci.org/codeclimate/minidoc.svg)](https://travis-ci.org/codeclimate/minidoc)
[![Gem Version](https://badge.fury.io/rb/minidoc.svg)](http://badge.fury.io/rb/minidoc)
[![Code Climate](https://codeclimate.com/github/codeclimate/minidoc/badges/gpa.svg)](https://codeclimate.com/github/codeclimate/minidoc)
[![Test Coverage](https://codeclimate.com/github/codeclimate/minidoc/badges/coverage.svg)](https://codeclimate.com/github/codeclimate/minidoc/coverage)

# Minidoc

Minidoc is an extremely lightweight layer on top of the MongoDB client to
make interacting with documents from Ruby more convenient.

We rely heavily on the MongoDB client, Virtus and ActiveModel to keep
things as simple as possible.

## Features

* Interact with Ruby objects instead of hashes
* Full access to the powerful MongoDB client
* Thread safe (hopefully)
* Simple and easily extensible
* ActiveModel-compatible
* Validations
* Timestamp tracking (created_at/updated_at)
* Very basic associations (for reads)
* Conversion into immutable value objects
* Read-only records

## Anti-Features

* Custom query API (just use Mongo)
* Callbacks (just define a method like save and call super)

## Installation

Add this line to your application's Gemfile:

```ruby
gem "minidoc"
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install minidoc
```

## Usage

### Setup

```ruby
Minidoc.connection = Mongo::Client.new("mongodb://localhost")
Minidoc.database_name = "my_great_app_development"
```

### Basics

```ruby
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
```

### Validations

Just uses [`ActiveModel::Validations`](http://api.rubyonrails.org/classes/ActiveModel/Validations.html):

```ruby
class User < Minidoc
  attribute :name, String

  validates :name, presence: true
end

user = User.new
user.valid? # => false
user.name = "Bryan"
user.valid? # => true
```

### Value Objects

```ruby
bryan = User.create(name: "Bryan").as_value
bryan.name #=> "Bryan"
bryan.name = "Brian" #=> NoMethodError
```

### Associations

```ruby
class Drink < Minidoc
  include Minidoc::Associations

  attribute :name, String

  belongs_to :user
end

bryan = User.create(name: "Bryan")
drink = Drink.create(name: "Paloma", user: bryan)
drink.user == bryan #=> true
```

### Read-only records

```ruby
class DrinkEvents < Minidoc::ReadOnly
  include Minidoc::Timestamps
  timestamps!
end

DrinkEvents.count(created_at: { "$gt": 4.days.ago }) #=> 0
DrinkEvents.create #=> NoMethodError
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/codeclimate/minidoc. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

When making a pull request, please update the [changelog](CHANGELOG.md).

## Releasing

* Update the changelog to mark the unreleased changes as part of the new release.
* Update the version.rb with the new version number
* Make a pull request with those changes
* Merge those changes to master
* Check out and pull down the latest master locally
* `rake release` which will
  * tag the latest commit based on version.rb
  * push to github
  * push to rubygems
* Copy the relevant changelog entries into a new [GitHub release](https://github.com/codeclimate/minidoc/releases).
