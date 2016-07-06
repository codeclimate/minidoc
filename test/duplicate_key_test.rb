require File.expand_path('../helper', __FILE__)

class DuplicateKeyTest < Minidoc::TestCase
  def test_rescue_duplicate_key_errors_result
    user = User.create!
    result = Minidoc.rescue_duplicate_key_errors do
      User.create!(name: "two")
    end

    assert_equal "two", result.name
  end

  def test_rescue_duplicate_key_errors_false
    user = User.create!
    result = Minidoc.rescue_duplicate_key_errors do
      User.create!(_id: user.id, name: "two")
    end

    assert_equal false, result
  end
end
