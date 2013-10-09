require File.expand_path('../../lib/filtered_set', __FILE__)
require 'minitest/autorun'

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

class FilteredSetTest < Minitest::Test
  def setup
    @enum = [-2, 3, -1, 1, -3, 2, 0]
  end

  def test_new
    assert_raises(ArgumentError) { FilteredSet.new }
    assert_raises(ArgumentError) { FilteredSet.new(@enum) }

    s = FilteredSet.new(@enum, &Arity1Filter.new)
    assert_equal [1,2,3], s.sort

    s = FilteredSet.new(@enum, Arity1Filter.new)
    assert_equal [1,2,3], s.sort

    s = FilteredSet.new(@enum, &Arity2Filter.new)
    assert_equal [-2,3], s.sort

    s = FilteredSet.new(@enum, Arity2Filter.new)
    assert_equal [-2,3], s.sort
  end

  def test_add
    s = FilteredSet.new(@enum, &Arity1Filter.new)
    assert_equal s, s.add(42)
    assert_equal [1,2,3,42], s.sort

    s = FilteredSet.new(@enum, Arity1Filter.new)
    assert_equal s, s.add(42)
    assert_equal [1,2,3,42], s.sort

    s = FilteredSet.new(@enum, &Arity2Filter.new)
    assert_equal s, s.add(42)
    assert_equal [-2,3,42], s.sort

    s = FilteredSet.new(@enum, Arity2Filter.new)
    assert_equal s, s.add(42)
    assert_equal [-2,3,42], s.sort
  end

  def test_add?
    s = FilteredSet.new(@enum, &Arity1Filter.new)
    assert_equal nil, s.add?(1)
    assert_equal s, s.add?(42)
    assert_equal [1,2,3,42], s.sort

    s = FilteredSet.new(@enum, Arity1Filter.new)
    assert_equal nil, s.add?(1)
    assert_equal s, s.add?(42)
    assert_equal [1,2,3,42], s.sort

    s = FilteredSet.new(@enum, &Arity2Filter.new)
    assert_equal nil, s.add?(1)
    assert_equal s, s.add?(42)
    assert_equal [-2,3,42], s.sort

    s = FilteredSet.new(@enum, Arity2Filter.new)
    assert_equal nil, s.add?(1)
    assert_equal s, s.add?(42)
    assert_equal [-2,3,42], s.sort
  end

  def test_replace
    other = [4,6,-4,5,3,-1]

    s = FilteredSet.new(@enum, &Arity1Filter.new)
    assert_equal [1,2,3], s.sort
    s.replace(other)
    assert_equal [3,4,5,6], s.sort

    s = FilteredSet.new(@enum, Arity1Filter.new)
    assert_equal [1,2,3], s.sort
    s.replace(other)
    assert_equal [3,4,5,6], s.sort

    s = FilteredSet.new(@enum, &Arity2Filter.new)
    assert_equal [-2,3], s.sort
    s.replace(other)
    assert_equal [4,6], s.sort

    s = FilteredSet.new(@enum, Arity2Filter.new)
    assert_equal [-2,3], s.sort
    s.replace(other)
    assert_equal [4,6], s.sort
  end

  def test_merge
    other = [4,6,-4,5,3,-1]

    s = FilteredSet.new(@enum, &Arity1Filter.new)
    assert_equal [1,2,3], s.sort
    s.merge(other)
    assert_equal [1,2,3,4,5,6], s.sort

    s = FilteredSet.new(@enum, Arity1Filter.new)
    assert_equal [1,2,3], s.sort
    s.merge(other)
    assert_equal [1,2,3,4,5,6], s.sort

    s = FilteredSet.new(@enum, &Arity2Filter.new)
    assert_equal [-2,3], s.sort
    s.merge(other)
    assert_equal [-2,3,4,6], s.sort

    s = FilteredSet.new(@enum, Arity2Filter.new)
    assert_equal [-2,3], s.sort
    s.merge(other)
    assert_equal [-2,3,4,6], s.sort
  end
end
