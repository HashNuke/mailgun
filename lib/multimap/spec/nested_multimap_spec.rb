require 'spec_helper'

describe NestedMultimap, "with inital values" do
  it_should_behave_like "Enumerable Multimap with inital values {'a' => [100], 'b' => [200, 300]}"
  it_should_behave_like "Hash Multimap with inital values {'a' => [100], 'b' => [200, 300]}"

  before do
    @map = NestedMultimap["a" => [100], "b" => [200, 300]]
  end

  it "should set value at nested key" do
    @map["foo", "bar", "baz"] = 100
    @map["foo", "bar", "baz"].should eql([100])
  end

  it "should allow nil keys to be set" do
    @map["b", nil] = 400
    @map["b", "c"] = 500

    @map["a"].should eql([100])
    @map["b"].should eql([200, 300])
    @map["b", nil].should eql([200, 300, 400])
    @map["b", "c"].should eql([200, 300, 500])
  end

  it "should treat missing keys as append to all" do
    @map[] = 400
    @map["a"].should eql([100, 400])
    @map["b"].should eql([200, 300, 400])
    @map["c"].should eql([400])
    @map[nil].should eql([400])
  end

  it "should append the value to default containers" do
    @map << 400
    @map["a"].should eql([100, 400])
    @map["b"].should eql([200, 300, 400])
    @map["c"].should eql([400])
    @map[nil].should eql([400])
  end

  it "should append the value to all containers" do
    @map << 500
    @map["a"].should eql([100, 500])
    @map["b"].should eql([200, 300, 500])
    @map[nil].should eql([500])
  end

  it "default values should be copied to new containers" do
    @map << 300
    @map["x"] = 100
    @map["x"].should eql([300, 100])
  end

  it "should list all containers" do
    @map.containers.should sorted_eql([[100], [200, 300]])
  end

  it "should list all values" do
    @map.values.should sorted_eql([100, 200, 300])
  end
end

describe NestedMultimap, "with nested values" do
  before do
    @map = NestedMultimap.new
    @map["a"] = 100
    @map["b"] = 200
    @map["b", "c"] = 300
    @map["c", "e"] = 400
    @map["c"] = 500
  end

  it "should retrieve container of values for key" do
    @map["a"].should eql([100])
    @map["b"].should eql([200])
    @map["c"].should eql([500])
    @map["a", "b"].should eql([100])
    @map["b", "c"].should eql([200, 300])
    @map["c", "e"].should eql([400, 500])
  end

  it "should append the value to default containers" do
    @map << 600
    @map["a"].should eql([100, 600])
    @map["b"].should eql([200, 600])
    @map["c"].should eql([500, 600])
    @map["a", "b"].should eql([100, 600])
    @map["b", "c"].should eql([200, 300, 600])
    @map["c", "e"].should eql([400, 500, 600])
    @map[nil].should eql([600])
  end

  it "should duplicate the containers" do
    map2 = @map.dup
    map2.should_not equal(@map)
    map2.should eql(@map)

    map2["a"].should eql([100])
    map2["b"].should eql([200])
    map2["c"].should eql([500])
    map2["a", "b"].should eql([100])
    map2["b", "c"].should eql([200, 300])
    map2["c", "e"].should eql([400, 500])

    map2["a"].should_not equal(@map["a"])
    map2["b"].should_not equal(@map["b"])
    map2["c"].should_not equal(@map["c"])
    map2["a", "b"].should_not equal(@map["a", "b"])
    map2["b", "c"].should_not equal(@map["b", "c"])
    map2["c", "e"].should_not equal(@map["c", "e"])

    map2.default.should_not equal(@map.default)
    map2.default.should eql(@map.default)
  end

  it "should iterate over each key/value pair and yield an array" do
    a = []
    @map.each { |pair| a << pair }
    a.should sorted_eql([
      ["a", 100],
      [["b", "c"], 200],
      [["b", "c"], 300],
      [["c", "e"], 400],
      [["c", "e"], 500]
    ])
  end

  it "should iterate over each key/container" do
    a = []
    @map.each_association { |key, container| a << [key, container] }
    a.should sorted_eql([
      ["a", [100]],
      [["b", "c"], [200, 300]],
      [["c", "e"], [400, 500]]
    ])
  end

  it "should iterate over each container plus the default" do
    a = []
    @map.each_container_with_default { |container| a << container }
    a.should sorted_eql([
      [100],
      [200, 300],
      [200],
      [400, 500],
      [500],
      []
    ])
  end

  it "should iterate over each key" do
    a = []
    @map.each_key { |key| a << key }
    a.should sorted_eql(["a", ["b", "c"], ["b", "c"], ["c", "e"], ["c", "e"]])
  end

  it "should iterate over each key/value pair and yield the pair" do
    h = {}
    @map.each_pair { |key, value| (h[key] ||= []) << value }
    h.should eql({
      "a" => [100],
      ["c", "e"] => [400, 500],
      ["b", "c"] => [200, 300]
    })
  end

  it "should iterate over each value" do
    a = []
    @map.each_value { |value| a << value }
    a.should sorted_eql([100, 200, 300, 400, 500])
  end

  it "should list all containers" do
    @map.containers.should sorted_eql([[100], [200, 300], [400, 500]])
  end

  it "should list all containers plus the default" do
    @map.containers_with_default.should sorted_eql([[100], [200, 300], [200], [400, 500], [500], []])
  end

  it "should return array of keys" do
    @map.keys.should eql(["a", ["b", "c"], ["b", "c"], ["c", "e"], ["c", "e"]])
  end

  it "should list all values" do
    @map.values.should sorted_eql([100, 200, 300, 400, 500])
  end
end

describe NestedMultimap, "with", Set do
  it_should_behave_like "Enumerable Multimap with inital values {'a' => [100], 'b' => [200, 300]}"
  it_should_behave_like "Hash Multimap with inital values {'a' => [100], 'b' => [200, 300]}"

  before do
    @container = Set
    @map = NestedMultimap.new(@container.new)
    @map["a"] = 100
    @map["b"] = 200
    @map["b"] = 300
  end
end
