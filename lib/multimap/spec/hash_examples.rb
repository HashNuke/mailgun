shared_examples_for Hash, Multimap, "with inital values {'a' => [100], 'b' => [200, 300]}" do
  before do
    @container ||= Array
  end

  it "should be equal to another Multimap if they contain the same keys and values" do
    map2 = Multimap.new(@container.new)
    map2["a"] = 100
    map2["b"] = 200
    map2["b"] = 300
    @map.should eql(map2)
  end

  it "should not be equal to another Multimap if they contain different values" do
    @map.should_not == Multimap["a" => [100], "b" => [200]]
  end

  it "should retrieve container of values for key" do
    @map["a"].should eql(@container.new([100]))
    @map["b"].should eql(@container.new([200, 300]))
    @map["z"].should eql(@container.new)
  end

  it "should append values to container at key" do
    @map["a"] = 400
    @map.store("b", 500)
    @map["a"].should eql(@container.new([100, 400]))
    @map["b"].should eql(@container.new([200, 300, 500]))
  end

  it "should clear all key/values" do
    @map.clear
    @map.should be_empty
  end

  it "should be the class of the container" do
    @map.default.class.should eql(@container)
  end

  it "should delete all values at key" do
    @map.delete("a")
    @map["a"].should eql(@container.new)
  end

  it "should delete single value at key" do
    @map.delete("b", 200)
    @map["b"].should eql(@container.new([300]))
  end

  it "should delete if key condition is matched" do
    @map.delete_if { |key, value| key >= "b" }.should eql(@map)
    @map["a"].should eql(@container.new([100]))
    @map["b"].should eql(@container.new)

    @map.delete_if { |key, value| key > "z" }.should eql(@map)
  end

  it "should delete if value condition is matched" do
    @map.delete_if { |key, value| value >= 300 }.should eql(@map)
    @map["a"].should eql(@container.new([100]))
    @map["b"].should eql(@container.new([200]))
  end

  it "should duplicate the containers" do
    map2 = @map.dup
    map2.should_not equal(@map)
    map2.should eql(@map)
    map2["a"].should_not equal(@map["a"])
    map2["b"].should_not equal(@map["b"])
    map2.default.should_not equal(@map.default)
    map2.default.should eql(@map.default)
  end

  it "should freeze containers" do
    @map.freeze
    @map.should be_frozen
    @map["a"].should be_frozen
    @map["b"].should be_frozen
  end

  it "should iterate over each key/value pair and yield an array" do
    a = []
    @map.each { |pair| a << pair }
    a.should sorted_eql([["a", 100], ["b", 200], ["b", 300]])
  end

  it "should iterate over each container" do
    a = []
    @map.each_container { |container| a << container }
    a.should sorted_eql([@container.new([100]), @container.new([200, 300])])
  end

  it "should iterate over each key/container" do
    a = []
    @map.each_association { |key, container| a << [key, container] }
    a.should sorted_eql([["a", @container.new([100])], ["b", @container.new([200, 300])]])
  end

  it "should iterate over each key" do
    a = []
    @map.each_key { |key| a << key }
    a.should sorted_eql(["a", "b", "b"])
  end

  it "should iterate over each key/value pair and yield the pair" do
    h = {}
    @map.each_pair { |key, value| (h[key] ||= []) << value }
    h.should eql({ "a" => [100], "b" => [200, 300] })
  end

  it "should iterate over each value" do
    a = []
    @map.each_value { |value| a << value }
    a.should sorted_eql([100, 200, 300])
  end

  it "should be empty if there are no key/value pairs" do
    @map.clear
    @map.should be_empty
  end

  it "should not be empty if there are any key/value pairs" do
    @map.should_not be_empty
  end

  it "should fetch container of values for key" do
    @map.fetch("a").should eql(@container.new([100]))
    @map.fetch("b").should eql(@container.new([200, 300]))
    lambda { @map.fetch("z") }.should raise_error(IndexError)
  end

  it "should check if key is present" do
    @map.has_key?("a").should be_true
    @map.key?("a").should be_true
    @map.has_key?("z").should be_false
    @map.key?("z").should be_false
  end

  it "should check containers when looking up by value" do
    @map.has_value?(100).should be_true
    @map.value?(100).should be_true
    @map.has_value?(999).should be_false
    @map.value?(999).should be_false
  end

  it "it should return the index for value" do
    if @map.respond_to?(:index)
      @map.index(200).should eql(@container.new(["b"]))
      @map.index(999).should eql(@container.new)
    end
  end

  it "should replace the contents of hash" do
    @map.replace({ "c" => @container.new([300]), "d" => @container.new([400]) })
    @map["a"].should eql(@container.new)
    @map["c"].should eql(@container.new([300]))
  end

  it "should return an inverted Multimap" do
    if @map.respond_to?(:invert)
      map2 = Multimap.new(@container.new)
      map2[100] = "a"
      map2[200] = "b"
      map2[300] = "b"
      @map.invert.should eql(map2)
    end
  end

  it "should return array of keys" do
    @map.keys.should eql(["a", "b", "b"])
  end

  it "should return the number of key/value pairs" do
    @map.length.should eql(3)
    @map.size.should eql(3)
  end

  it "should duplicate map and with merged values" do
    map = @map.merge("b" => 254, "c" => @container.new([300]))
    map["a"].should eql(@container.new([100]))
    map["b"].should eql(@container.new([200, 300, 254]))
    map["c"].should eql(@container.new([300]))

    @map["a"].should eql(@container.new([100]))
    @map["b"].should eql(@container.new([200, 300]))
    @map["c"].should eql(@container.new)
  end

  it "should update map" do
    @map.update("b" => 254, "c" => @container.new([300]))
    @map["a"].should eql(@container.new([100]))
    @map["b"].should eql(@container.new([200, 300, 254]))
    @map["c"].should eql(@container.new([300]))

    klass = @map.class
    @map.update(klass[@container.new, {"a" => @container.new([400, 500]), "c" => 600}])
    @map["a"].should eql(@container.new([100, 400, 500]))
    @map["b"].should eql(@container.new([200, 300, 254]))
    @map["c"].should eql(@container.new([300, 600]))
  end

  it "should reject key pairs on copy of the map" do
    map = @map.reject { |key, value| key >= "b" }
    map["b"].should eql(@container.new)
    @map["b"].should eql(@container.new([200, 300]))
  end

  it "should reject value pairs on copy of the map" do
    map = @map.reject { |key, value| value >= 300 }
    map["b"].should eql(@container.new([200]))
    @map["b"].should eql(@container.new([200, 300]))
  end

  it "should reject key pairs" do
    @map.reject! { |key, value| key >= "b" }.should eql(@map)
    @map["a"].should eql(@container.new([100]))
    @map["b"].should eql(@container.new)

    @map.reject! { |key, value| key >= "z" }.should eql(nil)
  end

  it "should reject value pairs" do
    @map.reject! { |key, value| value >= 300 }.should eql(@map)
    @map["a"].should eql(@container.new([100]))
    @map["b"].should eql(@container.new([200]))

    @map.reject! { |key, value| key >= "z" }.should eql(nil)
  end

  it "should select key/value pairs" do
    @map.select { |k, v| k > "a" }.should eql(Multimap["b", [200, 300]])
    @map.select { |k, v| v < 200 }.should eql(Multimap["a", 100])
  end

  it "should convert to hash" do
    @map.to_hash["a"].should eql(@container.new([100]))
    @map.to_hash["b"].should eql(@container.new([200, 300]))
    @map.to_hash.should_not equal(@map)
  end

  it "should return all containers" do
    @map.containers.should sorted_eql([@container.new([100]), @container.new([200, 300])])
  end

  it "should return all values" do
    @map.values.should sorted_eql([100, 200, 300])
  end

  it "should return return values at keys" do
    @map.values_at("a", "b").should eql([@container.new([100]), @container.new([200, 300])])
  end

  it "should marshal hash" do
    data = Marshal.dump(@map)
    Marshal.load(data).should eql(@map)
  end

  it "should dump yaml" do
    require 'yaml'

    data = YAML.dump(@map)
    YAML.load(data).should eql(@map)
  end
end
