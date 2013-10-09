require 'spec_helper'

describe FilteredSet do
  class TestFilter
    def to_proc() method(:call).to_proc end
  end

  class Arity1Filter < TestFilter
    def call(o)
      o > 0
    end
  end

  class Arity2Filter < TestFilter
    def call(list, o)
      if list.any? then o > list.max else true end
    end
  end

  let(:enum) { [-2, 3, -1, 1, -3, 2, 0] }

  describe ".new" do
    it "requires a callable filter" do
      expect { FilteredSet.new }.to raise_error(ArgumentError)
      expect { FilteredSet.new(enum) }.to raise_error(ArgumentError)

      expect {
        FilteredSet.new(enum, &Arity1Filter.new)
        FilteredSet.new(enum, Arity1Filter.new)
        FilteredSet.new(nil, Arity1Filter.new)

        FilteredSet.new(enum, &Arity2Filter.new)
        FilteredSet.new(enum, Arity2Filter.new)
        FilteredSet.new(nil, Arity2Filter.new)
      }.not_to raise_error
    end

    it "applies the filter" do
      s = FilteredSet.new(enum, &Arity1Filter.new)
      expect(s.sort).to eq [1, 2, 3]

      s = FilteredSet.new(enum, Arity1Filter.new)
      expect(s.sort).to eq [1, 2, 3]

      s = FilteredSet.new(enum, &Arity2Filter.new)
      expect(s.sort).to eq [-2, 3]

      s = FilteredSet.new(enum, Arity2Filter.new)
      expect(s.sort).to eq [-2, 3]
    end
  end

  describe "#replace" do
    it "applies the filter " do
      other = [4, 6, -4, 5, 3, -1]

      s = FilteredSet.new(enum, &Arity1Filter.new)
      expect(s.sort).to eq [1, 2, 3]
      s.replace(other)
      expect(s.sort).to eq [3, 4, 5, 6]

      s = FilteredSet.new(enum, Arity1Filter.new)
      expect(s.sort).to eq [1, 2, 3]
      s.replace(other)
      expect(s.sort).to eq [3, 4, 5, 6]

      s = FilteredSet.new(enum, &Arity2Filter.new)
      expect(s.sort).to eq [-2, 3]
      s.replace(other)
      expect(s.sort).to eq [4, 6]

      s = FilteredSet.new(enum, Arity2Filter.new)
      expect(s.sort).to eq [-2, 3]
      s.replace(other)
      expect(s.sort).to eq [4, 6]
    end
  end

  describe "#merge" do
    it "applies the filter" do
      other = [4, 6, -4, 5, 3, -1]

      s = FilteredSet.new(enum, &Arity1Filter.new)
      expect(s.sort).to eq [1, 2, 3]
      s.merge(other)
      expect(s.sort).to eq [1, 2, 3, 4, 5, 6]

      s = FilteredSet.new(enum, Arity1Filter.new)
      expect(s.sort).to eq [1, 2, 3]
      s.merge(other)
      expect(s.sort).to eq [1, 2, 3, 4, 5, 6]

      s = FilteredSet.new(enum, &Arity2Filter.new)
      expect(s.sort).to eq [-2, 3]
      s.merge(other)
      expect(s.sort).to eq [-2, 3, 4, 6]

      s = FilteredSet.new(enum, Arity2Filter.new)
      expect(s.sort).to eq [-2, 3]
      s.merge(other)
      expect(s.sort).to eq [-2, 3, 4, 6]
    end
  end
end
