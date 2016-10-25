require "spec_helper"

describe Minidoc::Counters do
  class SimpleCounter < Minidoc
    include Minidoc::Counters

    counter :counter
  end

  class AdvancedCounter < Minidoc
    include Minidoc::Counters

    counter :counter, start: 2, step_size: 3
  end

  describe "#increment_counter" do
    it "increments the field" do
      x = SimpleCounter.create!
      expect(x.counter).to eq 0
      expect(x.increment_counter).to eq 1
      expect(x.increment_counter).to eq 2
      expect(x.increment_counter).to eq 3
      expect(x.reload.counter).to eq 3
    end

    it "can be customized with some options" do
      x = AdvancedCounter.create!
      expect(x.counter).to eq 2
      expect(x.increment_counter).to eq 5
      expect(x.increment_counter).to eq 8
      expect(x.increment_counter).to eq 11
      expect(x.reload.counter).to eq 11
    end

    it "is thread safe" do
      x = SimpleCounter.create!
      counters = []
      [Thread.new { 5.times { (counters << x.increment_counter) } }, Thread.new { 5.times { (counters << x.increment_counter) } }, Thread.new { 5.times { (counters << x.increment_counter) } }].map(&:join)
      expect(counters.uniq.length).to eq 15
    end
  end
end
