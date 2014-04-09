$: << 'lib'
require 'nested_multimap'

hash = { "a" => true }

map = NestedMultimap.new
map["a"] = 100
map["a", "b", "c"] = 200
map["a", "b", "c", "d", "e", "f"] = 300

require 'benchmark'

TIMES = 100_000
Benchmark.bmbm do |x|
  x.report("base:")    { TIMES.times { hash["a"] } }
  x.report("best:")    { TIMES.times { map["a"] } }
  x.report("average:") { TIMES.times { map["a", "b", "c"] } }
  x.report("worst:")   { TIMES.times { map["a", "b", "c", "d", "e", "f"] } }
end

#   Pure Ruby
#                user     system      total        real
# base:      0.050000   0.000000   0.050000 (  0.049722)
# best:      0.480000   0.010000   0.490000 (  0.491012)
# average:   0.770000   0.000000   0.770000 (  0.773535)
# worst:     1.120000   0.010000   1.130000 (  1.139097)

#   C extension
#                user     system      total        real
# base:      0.050000   0.000000   0.050000 (  0.050990)
# best:      0.090000   0.000000   0.090000 (  0.088981)
# average:   0.130000   0.000000   0.130000 (  0.132098)
# worst:     0.150000   0.000000   0.150000 (  0.158293)
