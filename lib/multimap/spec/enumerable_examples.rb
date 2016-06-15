shared_examples_for Enumerable, Multimap, "with inital values {'a' => [100], 'b' => [200, 300]}" do
  it "should check all key/value pairs for condition" do
    expect(@map.all? { |key, value| key =~ /\w/ }).to be_true
    expect(@map.all? { |key, value| key =~ /\d/ }).to be_false
    expect(@map.all? { |key, value| value > 0 }).to be_true
    expect(@map.all? { |key, value| value > 200 }).to be_false
  end

  it "should check any key/value pairs for condition" do
    expect(@map.any? { |key, value| key == "a" }).to be_true
    expect(@map.any? { |key, value| key == "z" }).to be_false
    expect(@map.any? { |key, value| value == 100 }).to be_true
    expect(@map.any? { |key, value| value > 1000 }).to be_false
  end

  it "should collect key/value pairs" do
    expect(@map.collect { |key, value| [key, value] }).to sorted_eql([["a", 100], ["b", 200], ["b", 300]])
    expect(@map.map { |key, value| [key, value] }).to sorted_eql([["a", 100], ["b", 200], ["b", 300]])
  end

  it "should detect key/value pair" do
    expect(@map.detect { |key, value| value > 200 }).to eql(["b", 300])
    expect(@map.find { |key, value| value > 200 }).to eql(["b", 300])
  end

  it "should return entries" do
    expect(@map.entries).to sorted_eql([["a", 100], ["b", 200], ["b", 300]])
    expect(@map.to_a).to sorted_eql([["a", 100], ["b", 200], ["b", 300]])
  end

  it "should find all key/value pairs" do
    expect(@map.find_all { |key, value| value >= 200 }).to eql([["b", 200], ["b", 300]])
    expect(@map.select { |key, value| value >= 200 }).to eql(Multimap["b", [200, 300]])
  end

  it "should combine key/value pairs with inject" do
    expect(@map.inject(0) { |sum, (key, value)| sum + value }).to eql(600)

    @map.inject(0) { |memo, (key, value)|
      memo > value ? memo : value
    expect(}).to eql(300)
  end

  it "should check for key membership" do
    expect(@map.member?("a")).to be_true
    expect(@map.include?("a")).to be_true
    expect(@map.member?("z")).to be_false
    expect(@map.include?("z")).to be_false
  end
end
