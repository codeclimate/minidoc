require "minidoc"
require "minidoc/value"

class Minidoc::ReadOnly < Minidoc::Value
  include Minidoc::Connection
  include Minidoc::Finders

  def self.connection
    super
  rescue MissingConfiguration, NoMethodError
    Minidoc.connection
  else
    raise "hell"
  end

  def self.database_name
    super
  rescue MissingConfiguration, NoMethodError
    Minidoc.database_name
  else
    raise "hell"
  end
end
