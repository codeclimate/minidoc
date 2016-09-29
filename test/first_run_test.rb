# encoding: utf-8
require File.expand_path('../helper', __FILE__)

class FirstRunTest < Minidoc::TestCase
  def test_missing_setup_values
    with_alternative_configuration do
      Minidoc.connection = nil
      Minidoc.database_name = nil

      ex =
        assert_raises Minidoc::MissingConfiguration do
          User.create(name: "Kären")
        end
      assert_equal ex.message, "Make sure to set Minidoc.connection"
    end
  end

  def test_missing_database_name_only
    with_alternative_configuration do
      Minidoc.database_name = nil

      ex =
        assert_raises Minidoc::MissingConfiguration do
          User.create(name: "Kären")
        end
      assert_equal ex.message, "Make sure to set Minidoc.database_name"
    end
  end

  private

  def with_alternative_configuration
    original_connection = Minidoc.connection
    original_database_name = Minidoc.database_name
    yield
  ensure
    Minidoc.connection = original_connection
    Minidoc.database_name = original_database_name
  end
end
