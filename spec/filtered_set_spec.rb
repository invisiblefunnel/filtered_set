require 'spec_helper'

describe FilteredSet do
  class OneArgFilter
    def call(o)
      o > 0
    end
  end

  class TwoArgFilter
    def call(list, o)
      if list.any? then o > list.max else true end
    end
  end

  let(:enum) { [-2, 3, -1, 1, -3, 2, 0] }
  let(:one_arg_filter) do
    Proc.new { |o| o > 0 }
  end
  let(:two_arg_filter) do
    Proc.new { |list, o| list.any? ? o > list.max : true }
  end

  describe ".new" do
    it "requires a callable filter" do
      expect { FilteredSet.new }.to raise_error(ArgumentError)
      expect { FilteredSet.new(enum) }.to raise_error(ArgumentError)

      expect {
        FilteredSet.new(enum, &one_arg_filter)
        FilteredSet.new(enum, OneArgFilter.new)
        FilteredSet.new(enum, &two_arg_filter)
        FilteredSet.new(enum, TwoArgFilter.new)
      }.not_to raise_error
    end

    it "applies the filter" do
      s = FilteredSet.new(enum, &one_arg_filter)
      expect(s.sort).to eq [1, 2, 3]

      s = FilteredSet.new(enum, OneArgFilter.new)
      expect(s.sort).to eq [1, 2, 3]

      s = FilteredSet.new(enum, &two_arg_filter)
      expect(s.sort).to eq [-2, 3]

      s = FilteredSet.new(enum, TwoArgFilter.new)
      expect(s.sort).to eq [-2, 3]
    end
  end

  describe "#replace" do
    it "applies the filter " do
      other = [4, 6, -4, 5, 3, -1]

      s = FilteredSet.new(enum, &one_arg_filter)
      expect(s.sort).to eq [1, 2, 3]
      s.replace(other)
      expect(s.sort).to eq [3, 4, 5, 6]

      s = FilteredSet.new(enum, OneArgFilter.new)
      expect(s.sort).to eq [1, 2, 3]
      s.replace(other)
      expect(s.sort).to eq [3, 4, 5, 6]

      s = FilteredSet.new(enum, &two_arg_filter)
      expect(s.sort).to eq [-2, 3]
      s.replace(other)
      expect(s.sort).to eq [4, 6]

      s = FilteredSet.new(enum, TwoArgFilter.new)
      expect(s.sort).to eq [-2, 3]
      s.replace(other)
      expect(s.sort).to eq [4, 6]
    end
  end

  describe "#merge" do
    it "applies the filter" do
      other = [4, 6, -4, 5, 3, -1]

      s = FilteredSet.new(enum, &one_arg_filter)
      expect(s.sort).to eq [1, 2, 3]
      s.merge(other)
      expect(s.sort).to eq [1, 2, 3, 4, 5, 6]

      s = FilteredSet.new(enum, OneArgFilter.new)
      expect(s.sort).to eq [1, 2, 3]
      s.merge(other)
      expect(s.sort).to eq [1, 2, 3, 4, 5, 6]

      s = FilteredSet.new(enum, &two_arg_filter)
      expect(s.sort).to eq [-2, 3]
      s.merge(other)
      expect(s.sort).to eq [-2, 3, 4, 6]

      s = FilteredSet.new(enum, TwoArgFilter.new)
      expect(s.sort).to eq [-2, 3]
      s.merge(other)
      expect(s.sort).to eq [-2, 3, 4, 6]
    end
  end
end
