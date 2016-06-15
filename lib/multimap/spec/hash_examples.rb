shared_examples_for Hash, Multimap, "with inital values {'a' => [100], 'b' => [200, 300]}" do
  before do
    @container ||= Array
  end

  it "should be equal to another Multimap if they contain the same keys and values" do
    map2 = Multimap.new(@container.new)
    map2["a"] = 100
    map2["b"] = 200
    map2["b"] = 300
    expect(@map).to eql(map2)
  end

  it "should not be equal to another Multimap if they contain different values" do
    expect(@map).to_not == Multimap["a" => [100], "b" => [200]]
  end

  it "should retrieve container of values for key" do
    expect(@map["a"]).to eql(@container.new([100]))
    expect(@map["b"]).to eql(@container.new([200, 300]))
    expect(@map["z"]).to eql(@container.new)
  end

  it "should append values to container at key" do
    @map["a"] = 400
    @map.store("b", 500)
    expect(@map["a"]).to eql(@container.new([100, 400]))
    expect(@map["b"]).to eql(@container.new([200, 300, 500]))
  end

  it "should clear all key/values" do
    @map.clear
    expect(@map).to be_empty
  end

  it "should be the class of the container" do
    expect(@map.default.class).to eql(@container)
  end

  it "should delete all values at key" do
    @map.delete("a")
    expect(@map["a"]).to eql(@container.new)
  end

  it "should delete single value at key" do
    @map.delete("b", 200)
    expect(@map["b"]).to eql(@container.new([300]))
  end

  it "should delete if key condition is matched" do
    expect(@map.delete_if { |key, value| key >= "b" }).to eql(@map)
    expect(@map["a"]).to eql(@container.new([100]))
    expect(@map["b"]).to eql(@container.new)

    expect(@map.delete_if { |key, value| key > "z" }).to eql(@map)
  end

  it "should delete if value condition is matched" do
    expect(@map.delete_if { |key, value| value >= 300 }).to eql(@map)
    expect(@map["a"]).to eql(@container.new([100]))
    expect(@map["b"]).to eql(@container.new([200]))
  end

  it "should duplicate the containers" do
    map2 = @map.dup
    expect(map2).to_not equal(@map)
    expect(map2).to eql(@map)
    expect(map2["a"]).to_not equal(@map["a"])
    expect(map2["b"]).to_not equal(@map["b"])
    expect(map2.default).to_not equal(@map.default)
    expect(map2.default).to eql(@map.default)
  end

  it "should freeze containers" do
    @map.freeze
    expect(@map).to be_frozen
    expect(@map["a"]).to be_frozen
    expect(@map["b"]).to be_frozen
  end

  it "should iterate over each key/value pair and yield an array" do
    a = []
    @map.each { |pair| a << pair }
    expect(a).to sorted_eql([["a", 100], ["b", 200], ["b", 300]])
  end

  it "should iterate over each container" do
    a = []
    @map.each_container { |container| a << container }
    expect(a).to sorted_eql([@container.new([100]), @container.new([200, 300])])
  end

  it "should iterate over each key/container" do
    a = []
    @map.each_association { |key, container| a << [key, container] }
    expect(a).to sorted_eql([["a", @container.new([100])], ["b", @container.new([200, 300])]])
  end

  it "should iterate over each key" do
    a = []
    @map.each_key { |key| a << key }
    expect(a).to sorted_eql(["a", "b", "b"])
  end

  it "should iterate over each key/value pair and yield the pair" do
    h = {}
    @map.each_pair { |key, value| (h[key] ||= []) << value }
    expect(h).to eql({ "a" => [100], "b" => [200, 300] })
  end

  it "should iterate over each value" do
    a = []
    @map.each_value { |value| a << value }
    expect(a).to sorted_eql([100, 200, 300])
  end

  it "should be empty if there are no key/value pairs" do
    @map.clear
    expect(@map).to be_empty
  end

  it "should not be empty if there are any key/value pairs" do
    expect(@map).to_not be_empty
  end

  it "should fetch container of values for key" do
    expect(@map.fetch("a")).to eql(@container.new([100]))
    expect(@map.fetch("b")).to eql(@container.new([200, 300]))
    expect(lambda { @map.fetch("z") }).to raise_error(IndexError)
  end

  it "should check if key is present" do
    expect(@map.has_key?("a")).to be_true
    expect(@map.key?("a")).to be_true
    expect(@map.has_key?("z")).to be_false
    expect(@map.key?("z")).to be_false
  end

  it "should check containers when looking up by value" do
    expect(@map.has_value?(100)).to be_true
    expect(@map.value?(100)).to be_true
    expect(@map.has_value?(999)).to be_false
    expect(@map.value?(999)).to be_false
  end

  it "it should return the index for value" do
    if @map.respond_to?(:index)
      expect(@map.index(200)).to eql(@container.new(["b"]))
      expect(@map.index(999)).to eql(@container.new)
    end
  end

  it "should replace the contents of hash" do
    @map.replace({ "c" => @container.new([300]), "d" => @container.new([400]) })
    expect(@map["a"]).to eql(@container.new)
    expect(@map["c"]).to eql(@container.new([300]))
  end

  it "should return an inverted Multimap" do
    if @map.respond_to?(:invert)
      map2 = Multimap.new(@container.new)
      map2[100] = "a"
      map2[200] = "b"
      map2[300] = "b"
      expect(@map.invert).to eql(map2)
    end
  end

  it "should return array of keys" do
    expect(@map.keys).to eql(["a", "b", "b"])
  end

  it "should return the number of key/value pairs" do
    expect(@map.length).to eql(3)
    expect(@map.size).to eql(3)
  end

  it "should duplicate map and with merged values" do
    map = @map.merge("b" => 254, "c" => @container.new([300]))
    expect(map["a"]).to eql(@container.new([100]))
    expect(map["b"]).to eql(@container.new([200, 300, 254]))
    expect(map["c"]).to eql(@container.new([300]))

    expect(@map["a"]).to eql(@container.new([100]))
    expect(@map["b"]).to eql(@container.new([200, 300]))
    expect(@map["c"]).to eql(@container.new)
  end

  it "should update map" do
    @map.update("b" => 254, "c" => @container.new([300]))
    expect(@map["a"]).to eql(@container.new([100]))
    expect(@map["b"]).to eql(@container.new([200, 300, 254]))
    expect(@map["c"]).to eql(@container.new([300]))

    klass = @map.class
    @map.update(klass[@container.new, {"a" => @container.new([400, 500]), "c" => 600}])
    expect(@map["a"]).to eql(@container.new([100, 400, 500]))
    expect(@map["b"]).to eql(@container.new([200, 300, 254]))
    expect(@map["c"]).to eql(@container.new([300, 600]))
  end

  it "should reject key pairs on copy of the map" do
    map = @map.reject { |key, value| key >= "b" }
    expect(map["b"]).to eql(@container.new)
    expect(@map["b"]).to eql(@container.new([200, 300]))
  end

  it "should reject value pairs on copy of the map" do
    map = @map.reject { |key, value| value >= 300 }
    expect(map["b"]).to eql(@container.new([200]))
    expect(@map["b"]).to eql(@container.new([200, 300]))
  end

  it "should reject key pairs" do
    expect(@map.reject! { |key, value| key >= "b" }).to eql(@map)
    expect(@map["a"]).to eql(@container.new([100]))
    expect(@map["b"]).to eql(@container.new)

    expect(@map.reject! { |key, value| key >= "z" }).to eql(nil)
  end

  it "should reject value pairs" do
    expect(@map.reject! { |key, value| value >= 300 }).to eql(@map)
    expect(@map["a"]).to eql(@container.new([100]))
    expect(@map["b"]).to eql(@container.new([200]))

    expect(@map.reject! { |key, value| key >= "z" }).to eql(nil)
  end

  it "should select key/value pairs" do
    expect(@map.select { |k, v| k > "a" }).to eql(Multimap["b", [200, 300]])
    expect(@map.select { |k, v| v < 200 }).to eql(Multimap["a", 100])
  end

  it "should convert to hash" do
    expect(@map.to_hash["a"]).to eql(@container.new([100]))
    expect(@map.to_hash["b"]).to eql(@container.new([200, 300]))
    expect(@map.to_hash).to_not equal(@map)
  end

  it "should return all containers" do
    expect(@map.containers).to sorted_eql([@container.new([100]), @container.new([200, 300])])
  end

  it "should return all values" do
    expect(@map.values).to sorted_eql([100, 200, 300])
  end

  it "should return return values at keys" do
    expect(@map.values_at("a", "b")).to eql([@container.new([100]), @container.new([200, 300])])
  end

  it "should marshal hash" do
    data = Marshal.dump(@map)
    expect(Marshal.load(data)).to eql(@map)
  end

  it "should dump yaml" do
    require 'yaml'

    data = YAML.dump(@map)
    expect(YAML.load(data)).to eql(@map)
  end
end
