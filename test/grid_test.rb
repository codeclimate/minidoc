require File.expand_path('../helper', __FILE__)

class GridTest < Minidoc::TestCase

  def setup
    super
    @grid = Minidoc::Grid.new(Minidoc.database)
  end

  def test_get_with_string
    doc_id = @grid.put("estamos en espana")
    as_string = doc_id.to_s
    document = @grid.get(as_string)
    assert_equal("estamos en espana", document.read)
  end

  def test_get_json
    hash = { "foo" => { "bar" => 1 } }
    doc_id = @grid.put(hash.to_json)
    as_string = doc_id.to_s
    assert_equal(hash, @grid.get_json(as_string))
  end

  def test_delete
    doc_id = @grid.put("estamos en espana")
    as_string = doc_id.to_s
    @grid.delete(as_string)
    assert_raises Mongo::GridFileNotFound do
      @grid.get(doc_id)
    end
  end

end
