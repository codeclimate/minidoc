require "minidoc"
require "minidoc/value"

class Minidoc::ReadOnly < Minidoc::Value
  include Minidoc::Connection
  include Minidoc::Finders

  def self.connection
    super
  rescue MissingConfiguration, NoMethodError
    Minidoc.connection
  end

  def self.database_name
    super
  rescue MissingConfiguration, NoMethodError
    Minidoc.database_name
  end
end
