require File.expand_path('../helper', __FILE__)

class AutoIncrementTest < Minidoc::TestCase
  class SimpleIncrement < Minidoc
    include Minidoc::AutoIncrement

    auto_increment :counter
  end

  class AdvancedIncrement < Minidoc
    include Minidoc::AutoIncrement

    auto_increment :counter, start: 2, step_size: 3
  end

  def test_incrementing
    x = SimpleIncrement.create!

    assert_equal 0, x.counter
    assert_equal 1, x.next_counter
    assert_equal 2, x.next_counter
    assert_equal 3, x.next_counter
    assert_equal 3, x.reload.counter
  end

  def test_options
    x = AdvancedIncrement.create!

    assert_equal 2, x.counter
    assert_equal 5, x.next_counter
    assert_equal 8, x.next_counter
    assert_equal 11, x.next_counter
    assert_equal 11, x.reload.counter
  end

  def test_threading
    x = SimpleIncrement.create!
    counters = []

    [
      Thread.new { 5.times { counters << x.next_counter } },
      Thread.new { 5.times { counters << x.next_counter } },
      Thread.new { 5.times { counters << x.next_counter } },
    ].map(&:join)

    assert_equal 15, counters.uniq.length
  end
end
