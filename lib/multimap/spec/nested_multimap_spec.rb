require 'spec_helper'

describe NestedMultimap, "with inital values" do
  it_should_behave_like "Enumerable Multimap with inital values {'a' => [100], 'b' => [200, 300]}"
  it_should_behave_like "Hash Multimap with inital values {'a' => [100], 'b' => [200, 300]}"

  before do
    @map = NestedMultimap["a" => [100], "b" => [200, 300]]
  end

  it "should set value at nested key" do
    @map["foo", "bar", "baz"] = 100
    expect(@map["foo", "bar", "baz"]).to eql([100])
  end

  it "should allow nil keys to be set" do
    @map["b", nil] = 400
    @map["b", "c"] = 500

    expect(@map["a"]).to eql([100])
    expect(@map["b"]).to eql([200, 300])
    expect(@map["b", nil]).to eql([200, 300, 400])
    expect(@map["b", "c"]).to eql([200, 300, 500])
  end

  it "should treat missing keys as append to all" do
    @map[] = 400
    expect(@map["a"]).to eql([100, 400])
    expect(@map["b"]).to eql([200, 300, 400])
    expect(@map["c"]).to eql([400])
    expect(@map[nil]).to eql([400])
  end

  it "should append the value to default containers" do
    @map << 400
    expect(@map["a"]).to eql([100, 400])
    expect(@map["b"]).to eql([200, 300, 400])
    expect(@map["c"]).to eql([400])
    expect(@map[nil]).to eql([400])
  end

  it "should append the value to all containers" do
    @map << 500
    expect(@map["a"]).to eql([100, 500])
    expect(@map["b"]).to eql([200, 300, 500])
    expect(@map[nil]).to eql([500])
  end

  it "default values should be copied to new containers" do
    @map << 300
    @map["x"] = 100
    expect(@map["x"]).to eql([300, 100])
  end

  it "should list all containers" do
    expect(@map.containers).to sorted_eql([[100], [200, 300]])
  end

  it "should list all values" do
    expect(@map.values).to sorted_eql([100, 200, 300])
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
    expect(@map["a"]).to eql([100])
    expect(@map["b"]).to eql([200])
    expect(@map["c"]).to eql([500])
    expect(@map["a", "b"]).to eql([100])
    expect(@map["b", "c"]).to eql([200, 300])
    expect(@map["c", "e"]).to eql([400, 500])
  end

  it "should append the value to default containers" do
    @map << 600
    expect(@map["a"]).to eql([100, 600])
    expect(@map["b"]).to eql([200, 600])
    expect(@map["c"]).to eql([500, 600])
    expect(@map["a", "b"]).to eql([100, 600])
    expect(@map["b", "c"]).to eql([200, 300, 600])
    expect(@map["c", "e"]).to eql([400, 500, 600])
    expect(@map[nil]).to eql([600])
  end

  it "should duplicate the containers" do
    map2 = @map.dup
    expect(map2).to_not equal(@map)
    expect(map2).to eql(@map)

    expect(map2["a"]).to eql([100])
    expect(map2["b"]).to eql([200])
    expect(map2["c"]).to eql([500])
    expect(map2["a", "b"]).to eql([100])
    expect(map2["b", "c"]).to eql([200, 300])
    expect(map2["c", "e"]).to eql([400, 500])

    expect(map2["a"]).to_not equal(@map["a"])
    expect(map2["b"]).to_not equal(@map["b"])
    expect(map2["c"]).to_not equal(@map["c"])
    expect(map2["a", "b"]).to_not equal(@map["a", "b"])
    expect(map2["b", "c"]).to_not equal(@map["b", "c"])
    expect(map2["c", "e"]).to_not equal(@map["c", "e"])

    expect(map2.default).to_not equal(@map.default)
    expect(map2.default).to eql(@map.default)
  end

  it "should iterate over each key/value pair and yield an array" do
    a = []
    @map.each { |pair| a << pair }
    expect(a).to sorted_eql([
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
    expect(a).to sorted_eql([
      ["a", [100]],
      [["b", "c"], [200, 300]],
      [["c", "e"], [400, 500]]
    ])
  end

  it "should iterate over each container plus the default" do
    a = []
    @map.each_container_with_default { |container| a << container }
    expect(a).to sorted_eql([
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
    expect(a).to sorted_eql(["a", ["b", "c"], ["b", "c"], ["c", "e"], ["c", "e"]])
  end

  it "should iterate over each key/value pair and yield the pair" do
    h = {}
    @map.each_pair { |key, value| (h[key] ||= []) << value }
    expect(h).to eql({
      "a" => [100],
      ["c", "e"] => [400, 500],
      ["b", "c"] => [200, 300]
    })
  end

  it "should iterate over each value" do
    a = []
    @map.each_value { |value| a << value }
    expect(a).to sorted_eql([100, 200, 300, 400, 500])
  end

  it "should list all containers" do
    expect(@map.containers).to sorted_eql([[100], [200, 300], [400, 500]])
  end

  it "should list all containers plus the default" do
    expect(@map.containers_with_default).to sorted_eql([[100], [200, 300], [200], [400, 500], [500], []])
  end

  it "should return array of keys" do
    expect(@map.keys).to eql(["a", ["b", "c"], ["b", "c"], ["c", "e"], ["c", "e"]])
  end

  it "should list all values" do
    expect(@map.values).to sorted_eql([100, 200, 300, 400, 500])
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
