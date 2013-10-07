# The following copyright notice is included because parts of this
# library are modified from code in MRI's codebase.

# Copyright (c) 2002-2013 Akinori MUSHA <knu@iDaemons.org>
#
# Documentation by Akinori MUSHA and Gavin Sinclair.
#
# All rights reserved.  You can redistribute and/or modify it under the same
# terms as Ruby.

require 'set'

class FilteredSet < Set
  Identity = lambda { |obj| obj }

  def initialize(enum = nil, filter = Proc.new)
    raise ArgumentError, "must provide a callable object" if !filter.respond_to?(:call)

    @filter = filter
    super(enum, &Identity)
  end

  def add(o)
    if @filter.call(self, o)
      @hash[o] = true
    end
    self
  end
  alias << add

  def add?(o)
    if include?(o) || !@filter.call(self, o)
      nil
    else
      @hash[o] = true
      self
    end
  end

  VERSION = "0.1.0"
end
