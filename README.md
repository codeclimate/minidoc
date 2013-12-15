[![Code Climate](https://codeclimate.com/github/brynary/minidoc.png)](https://codeclimate.com/github/brynary/minidoc)

# Minidoc

Minidoc is an extremely lightweight layer on top of the MongoDB client to
make interacting with documents from Ruby more convenient.

We rely heavily on the MongoDB client, Virtus and ActiveModel to keep things
as simple as possible.

## Features

* Interact with Ruby objects instead of hashes
* Full access to the powerful MongoDB client
* Thread safe. (Hopefully)
* Simple and easily extensible (Less than 500 lines of code.)
* Validations
* Read only records
* Timestamp tracking (created_at/updated_at)
* ActiveModel-compatible
* Attribute aliasing
* Very basic associations (for reads)

## Anti-Features

* Custom query API (just use Mongo)
* Callbacks (just define a method like save and call super)

## Usage

### Basics
### Validations
### Value Objects
### Embedded Documents
### Associations
