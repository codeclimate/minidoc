require "minidoc"
require "minidoc/value"

class Minidoc::ReadOnly < Minidoc::Value
  include Minidoc::Connection
  include Minidoc::Finders

  def self.database
    Minidoc.database
  end
end
