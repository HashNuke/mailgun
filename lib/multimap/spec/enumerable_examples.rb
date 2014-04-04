shared_examples_for Enumerable, Multimap, "with inital values {'a' => [100], 'b' => [200, 300]}" do
  it "should check all key/value pairs for condition" do
    @map.all? { |key, value| key =~ /\w/ }.should be_true
    @map.all? { |key, value| key =~ /\d/ }.should be_false
    @map.all? { |key, value| value > 0 }.should be_true
    @map.all? { |key, value| value > 200 }.should be_false
  end

  it "should check any key/value pairs for condition" do
    @map.any? { |key, value| key == "a" }.should be_true
    @map.any? { |key, value| key == "z" }.should be_false
    @map.any? { |key, value| value == 100 }.should be_true
    @map.any? { |key, value| value > 1000 }.should be_false
  end

  it "should collect key/value pairs" do
    @map.collect { |key, value| [key, value] }.should sorted_eql([["a", 100], ["b", 200], ["b", 300]])
    @map.map { |key, value| [key, value] }.should sorted_eql([["a", 100], ["b", 200], ["b", 300]])
  end

  it "should detect key/value pair" do
    @map.detect { |key, value| value > 200 }.should eql(["b", 300])
    @map.find { |key, value| value > 200 }.should eql(["b", 300])
  end

  it "should return entries" do
    @map.entries.should sorted_eql([["a", 100], ["b", 200], ["b", 300]])
    @map.to_a.should sorted_eql([["a", 100], ["b", 200], ["b", 300]])
  end

  it "should find all key/value pairs" do
    @map.find_all { |key, value| value >= 200 }.should eql([["b", 200], ["b", 300]])
    @map.select { |key, value| value >= 200 }.should eql(Multimap["b", [200, 300]])
  end

  it "should combine key/value pairs with inject" do
    @map.inject(0) { |sum, (key, value)| sum + value }.should eql(600)

    @map.inject(0) { |memo, (key, value)|
      memo > value ? memo : value
    }.should eql(300)
  end

  it "should check for key membership" do
    @map.member?("a").should be_true
    @map.include?("a").should be_true
    @map.member?("z").should be_false
    @map.include?("z").should be_false
  end
end
