require 'multiset'
require 'multimap'
require 'nested_multimap'

require 'enumerable_examples'
require 'hash_examples'
require 'set_examples'

# Rubinius Hash isn't ordered by insert order
Spec::Matchers.define :sorted_eql do |expected|
  if defined? Rubinius
    sorter = lambda { |a, b| a.hash <=> b.hash }
    match do |actual|
      actual.sort(&sorter).should eql(expected.sort(&sorter))
    end
  else
    match do |actual|
      actual.should eql(expected)
    end
  end
end

require 'set'

if defined? Rubinius
  class Set
    def <=>(other)
      to_a <=> other.to_a
    end
  end
end

require 'forwardable'

class MiniArray
  extend Forwardable

  attr_accessor :data

  def initialize(data = [])
    @data = data
  end

  def initialize_copy(orig)
    @data = orig.data.dup
  end

  def_delegators :@data, :<<, :each, :delete, :delete_if

  def ==(other)
    other.is_a?(self.class) && @data == other.data
  end

  def eql?(other)
    other.is_a?(self.class) && @data.eql?(other.data)
  end

  if defined? Rubinius
    def hash
      @data.hash
    end

    def <=>(other)
      @data <=> other.data
    end
  end
end
