# FilteredSet [![Build Status](https://secure.travis-ci.org/invisiblefunnel/filtered_set.png?branch=master)](http://travis-ci.org/invisiblefunnel/filtered_set)

FilteredSet is an implementation of Ruby's Set which conditionally adds objects based on custom filters. It was adapted from the incomplete [RestrictedSet][ruby-restricted-set] described in MRI's codebase. The main improvement over RestrictedSet is that in addition to blocks, an object which responds to `#call` can be passed as a filter. FilteredSet also avoids using `instance_eval` to conditionally define methods on each instance.

This library is distributed under the same terms as [Ruby][ruby].

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'filtered_set', github: 'invisiblefunnel/filtered_set'
```

And then execute:

```console
$ bundle
```

## Usage

```ruby
# Filter block which rejects an object if the return value is falsey.
set = FilteredSet.new(-2..2) { |obj| obj > 0 }
set.sort #=> [1, 2]
```

```ruby
# Callable object with filter logic
class WhitelistFilter
  def initialize(*allowed)
    @allowed = allowed
  end

  def call(obj)
    @allowed.include?(obj)
  end
end

set = FilteredSet.new([:age, :location], WhitelistFilter.new(:name, :email))
set.to_a #=> []
set.add(:name)
set.to_a #=> [:name]
```

```ruby
# The set in itself will be passed to filters with an arity of 2
ascending_filter = lambda do |list, obj|
  if list.any?
    obj > list.max
  else
    true
  end
end

set = FilteredSet.new(nil, ascending_filter)
set.add(10)
set.sort #=> [10]
set.add(9)
set.add(11)
set.sort #=> [10, 11]
```

```ruby
# Declare reusable filtered sets with inheritance
class SymbolSet < FilteredSet
  def initialize(enum)
    super(enum) { |o| Symbol === o }
  end
end

SymbolSet["api_key", :api_key, :api_key]  #=> #<SymbolSet: {:api_key}>
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[ruby-restricted-set]: https://github.com/ruby/ruby/blob/a8178c69bee18250aa022bb270390279487a8618/lib/set.rb#L675-L765
[ruby]: https://github.com/ruby/ruby
