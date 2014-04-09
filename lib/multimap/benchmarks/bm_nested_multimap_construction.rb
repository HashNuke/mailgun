$: << 'lib'
require 'nested_multimap'

tiny_mapping = {
  ["a"] => 100
}

medium_mapping = {
  ["a"] => 100,
  ["a", "b", "c"] => 200,
  ["b"] => 300,
  ["b", "c"] => 400,
  ["c"] => 500,
  ["c", "d"] => 600,
  ["c", "d", "e"] => 700,
  ["c", "d", "e", "f"] => 800
}

huge_mapping = {}
alpha = ("a".."zz").to_a
100.times do |n|
  keys = ("a"..alpha[n % alpha.length]).to_a
  huge_mapping[keys] = n * 100
end

require 'benchmark'

Benchmark.bmbm do |x|
  x.report("base:") {
    NestedMultimap.new
  }

  x.report("tiny:") {
    map = NestedMultimap.new
    tiny_mapping.each_pair { |keys, value|
      map[*keys] = value
    }
  }

  x.report("medium:") {
    map = NestedMultimap.new
    medium_mapping.each_pair { |keys, value|
      map[*keys] = value
    }
  }

  x.report("huge:") {
    map = NestedMultimap.new
    huge_mapping.each_pair { |keys, value|
      map[*keys] = value
    }
  }
end

#   Pure Ruby
#               user     system      total        real
# base:     0.000000   0.000000   0.000000 (  0.000014)
# tiny:     0.000000   0.000000   0.000000 (  0.000054)
# medium:   0.000000   0.000000   0.000000 (  0.000186)
# huge:     0.050000   0.000000   0.050000 (  0.051302)
