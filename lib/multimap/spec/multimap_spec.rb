require 'spec_helper'

describe Multimap, "with inital values {'a' => [100], 'b' => [200, 300]}" do
  it_should_behave_like "Enumerable Multimap with inital values {'a' => [100], 'b' => [200, 300]}"
  it_should_behave_like "Hash Multimap with inital values {'a' => [100], 'b' => [200, 300]}"

  before do
    @map = Multimap["a" => 100, "b" => [200, 300]]
  end
end

describe Multimap, "with inital values {'a' => [100], 'b' => [200, 300]}" do
  it_should_behave_like "Enumerable Multimap with inital values {'a' => [100], 'b' => [200, 300]}"
  it_should_behave_like "Hash Multimap with inital values {'a' => [100], 'b' => [200, 300]}"

  before do
    @map = Multimap["a", 100, "b", [200, 300]]
  end
end

describe Multimap, "with", Set do
  it_should_behave_like "Enumerable Multimap with inital values {'a' => [100], 'b' => [200, 300]}"
  it_should_behave_like "Hash Multimap with inital values {'a' => [100], 'b' => [200, 300]}"

  before do
    @container = Set
    @map = Multimap.new(@container.new)
    @map["a"] = 100
    @map["b"] = 200
    @map["b"] = 300
  end
end

describe Multimap, "with", MiniArray do
  it_should_behave_like "Enumerable Multimap with inital values {'a' => [100], 'b' => [200, 300]}"
  it_should_behave_like "Hash Multimap with inital values {'a' => [100], 'b' => [200, 300]}"

  before do
    @container = MiniArray
    @map = Multimap.new(@container.new)
    @map["a"] = 100
    @map["b"] = 200
    @map["b"] = 300
  end
end
