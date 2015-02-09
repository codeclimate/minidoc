require File.expand_path('../helper', __FILE__)

class IndexesTest < Minidoc::TestCase
  class Company < Minidoc
    self.collection_name = "accounts"

    include Minidoc::Indexes

    attribute :name
    attribute :title
    attribute :description
  end

  def test_ensure_index_single
    Company.ensure_index(:name)

    assert_equal %w( name ), indexed_keys(Company, "name_1")
  end

  def test_ensure_index_multiple
    Company.ensure_index([:name, :title])

    assert_equal %w( name title ), indexed_keys(Company, "name_1_title_1")
  end

  def test_ensure_index_options
    Company.ensure_index(:name, unique: true)

    assert index_info(Company, "name_1")["unique"]
  end

  def test_rescue_duplicate_key_errors_not_raising_exception
    Company.ensure_index(:name, unique: true)

    Company.rescue_duplicate_key_errors do
      Company.create!(name: "CodeClimate")
      Company.create!(name: "CodeClimate")
    end
  end

  private

  def index_info(klass, name)
    klass.collection.index_information[name] || {}
  end

  def indexed_keys(klass, name)
    key_info = index_info(klass, name)["key"] || {}
    key_info.keys
  end

end
