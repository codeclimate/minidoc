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
    Company.ensure_index(:name, :title)

    assert_equal %w( name title ), indexed_keys(Company, "name_1_title_1")
  end

  private

  def indexed_keys(klass, name)
    index = klass.collection.index_information[name] || {}
    index_info = index["key"] || {}

    index_info.keys
  end

end
