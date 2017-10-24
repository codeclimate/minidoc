require "minidoc"
require "minidoc/value"

class Minidoc::ReadOnly < Minidoc::Value
  include Minidoc::Connection
  include Minidoc::Finders

  # This and `self.database_name` are deleted & redefined by `class_attribute`
  # when you call `.connection=` or `.database_name=`, so these still allow
  # `ReadOnly` subclasses to override their connection details
  def self.connection
    Minidoc.connection
  end

  def self.database_name
    Minidoc.database_name
  end
end
