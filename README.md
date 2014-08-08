[![Code Climate](https://codeclimate.com/github/brynary/minidoc.svg)](https://codeclimate.com/github/brynary/minidoc)
[![Build Status](https://travis-ci.org/brynary/minidoc.svg)](https://travis-ci.org/brynary/minidoc)

# Minidoc

Minidoc is an extremely lightweight layer on top of the MongoDB client to
make interacting with documents from Ruby more convenient.

We rely heavily on the MongoDB client, Virtus and ActiveModel to keep
things as simple as possible.

## Features

* Interact with Ruby objects instead of hashes
* Full access to the powerful MongoDB client
* Thread safe. (Hopefully)
* Simple and easily extensible (Less than 500 lines of code.)
* ActiveModel-compatible
* Validations
* Timestamp tracking (created_at/updated_at)
* Very basic associations (for reads)
* Conversion into immutable value objects
* Read-only records

## Anti-Features

* Custom query API (just use Mongo)
* Callbacks (just define a method like save and call super)

## Usage

    gem "minidoc", "~> 0.0.1"

### Basics

```ruby
class User < Minidoc
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

### Associations

### Read-only records
