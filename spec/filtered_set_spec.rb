require 'spec_helper'

describe FilteredSet do
  let(:enum) { [2, 0, -1, 1, 0] }
  let(:filter) { Proc.new { |list, obj| obj > 0 } }

  describe ".new" do
    context "given an enumerable object" do
      it "raise an error given no filter argument" do
        expect { FilteredSet.new(enum) }.to raise_error(ArgumentError)
      end

      it "raises an error given an object which does not respond to #call" do
        expect { FilteredSet.new(enum, Object.new) }.to raise_error(ArgumentError)
      end

      it "applies a block filter" do
        s = FilteredSet.new(enum, &filter)
        expect(s.sort).to eq [1, 2]
      end

      it "applies a callable object filter" do
        s = FilteredSet.new(enum, filter)
        expect(s.sort).to eq [1, 2]
      end
    end

    context "not given an enumerable object" do
      it "raise an error given no filter argument" do
        expect { FilteredSet.new }.to raise_error(ArgumentError)
      end

      it "raises an error given an object which does not respond to #call" do
        expect { FilteredSet.new(nil, Object.new) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#add" do
    it "applies the filter" do
      s = FilteredSet.new(&filter)

      expect(s.add(-5)).to eq s
      expect(s.add(0)).to eq s
      expect(s.add(5)).to eq s
      expect(s.add(6)).to eq s

      expect(s.sort).to eq [5, 6]
    end
  end

  describe "#add?" do
    it "applies the filter" do
      s = FilteredSet.new(&filter)

      expect(s.add?(1)).to eq s
      expect(s.add?(0)).to be_nil
      expect(s.add?(2)).to eq s

      expect(s.sort).to eq [1, 2]
    end
  end

  describe "#replace" do
    it "applies the filter" do
      s = FilteredSet.new(enum, &filter)
      expect(s.sort).to eq [1, 2]

      s.replace([4, 2, 3, -1])
      expect(s.sort).to eq [2, 3, 4]
    end
  end

  describe "#merge" do
    it "applies the filter" do
      s = FilteredSet.new(&filter)
      s.merge(-3..3)
      expect(s.sort).to eq [1, 2, 3]

      s.merge([-4, 10])
      expect(s.sort).to eq [1, 2, 3, 10]
    end
  end
end
