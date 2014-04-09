shared_examples_for Set do
  it "should create a new set containing the given objects" do
    Multiset[]
    Multiset[nil]
    Multiset[1, 2, 3]

    Multiset[].size.should eql(0)
    Multiset[nil].size.should eql(1)
    Multiset[[]].size.should eql(1)
    Multiset[[nil]].size.should eql(1)

    set = Multiset[2, 4, 6, 4]
    Multiset.new([2, 4, 6]).should_not eql(set)

    set = Multiset[2, 4, 6, 4]
    Multiset.new([2, 4, 6, 4]).should eql(set)
  end

  it "should create a new set containing the elements of the given enumerable object" do
    Multiset.new()
    Multiset.new(nil)
    Multiset.new([])
    Multiset.new([1, 2])
    Multiset.new('a'..'c')

    lambda { Multiset.new(false) }.should raise_error
    lambda { Multiset.new(1) }.should raise_error
    lambda { Multiset.new(1, 2) }.should raise_error

    Multiset.new().size.should eql(0)
    Multiset.new(nil).size.should eql(0)
    Multiset.new([]).size.should eql(0)
    Multiset.new([nil]).size.should eql(1)

    ary = [2, 4, 6, 4]
    set = Multiset.new(ary)
    ary.clear
    set.should_not be_empty
    set.size.should eql(4)

    ary = [1, 2, 3]

    s = Multiset.new(ary) { |o| o * 2 }
    [2, 4, 6].should eql(s.sort)
  end

  it "should duplicate set" do
    set1 = Multiset[1, 2]
    set2 = set1.dup

    set1.should_not equal(set2)

    set1.should eql(set2)

    set1.add(3)

    set1.should_not eql(set2)
  end

  it "should return the number of elements" do
    Multiset[].size.should eql(0)
    Multiset[1, 2].size.should eql(2)
    Multiset[1, 2, 1].size.should eql(3)
  end

  it "should return true if the set contains no elements" do
    Multiset[].should be_empty
    Multiset[1, 2].should_not be_empty
  end

  it "should remove all elements and returns self" do
    set = Multiset[1, 2]
    ret = set.clear

    set.should equal(ret)
    set.should be_empty
  end

  it "should replaces the contents of the set with the contents of the given enumerable object and returns self" do
    set = Multiset[1, 2]
    ret = set.replace('a'..'c')

    set.should equal(ret)
    set.should eql(Multiset['a', 'b', 'c'])
  end

  it "should convert the set to an array" do
    set = Multiset[1, 2, 3, 2]
    ary = set.to_a

    ary.sort.should eql([1, 2, 2, 3])
  end

  it "should return true if the set contains the given object" do
    set = Multiset[1, 2, 3]

    set.include?(1).should be_true
    set.include?(2).should be_true
    set.include?(3).should be_true
    set.include?(0).should be_false
    set.include?(nil).should be_false

    set = Multiset["1", nil, "2", nil, "0", "1", false]
    set.include?(nil).should be_true
    set.include?(false).should be_true
    set.include?("1").should be_true
    set.include?(0).should be_false
    set.include?(true).should be_false
  end

  it "should return true if the set is a superset of the given set" do
    set = Multiset[1, 2, 3]

    lambda { set.superset?() }.should raise_error
    lambda { set.superset?(2) }.should raise_error
    lambda { set.superset?([2]) }.should raise_error

    set.superset?(Multiset[]).should be_true
    set.superset?(Multiset[1, 2]).should be_true
    set.superset?(Multiset[1, 2, 3]).should be_true
    set.superset?(Multiset[1, 2, 3, 4]).should be_false
    set.superset?(Multiset[1, 4]).should be_false

    Multiset[].superset?(Multiset[]).should be_true
  end

  it "should return true if the set is a proper superset of the given set" do
    set = Multiset[1, 2, 3]

    lambda { set.proper_superset?() }.should raise_error
    lambda { set.proper_superset?(2) }.should raise_error
    lambda { set.proper_superset?([2]) }.should raise_error

    set.proper_superset?(Multiset[]).should be_true
    set.proper_superset?(Multiset[1, 2]).should be_true
    set.proper_superset?(Multiset[1, 2, 3]).should be_false
    set.proper_superset?(Multiset[1, 2, 3, 4]).should be_false
    set.proper_superset?(Multiset[1, 4]).should be_false

    Multiset[].proper_superset?(Multiset[]).should be_false
  end

  it "should return true if the set is a subset of the given set" do
    set = Multiset[1, 2, 3]

    lambda { set.subset?() }.should raise_error
    lambda { set.subset?(2) }.should raise_error
    lambda { set.subset?([2]) }.should raise_error

    set.subset?(Multiset[1, 2, 3, 4]).should be_true
    set.subset?(Multiset[1, 2, 3]).should be_true
    set.subset?(Multiset[1, 2]).should be_false
    set.subset?(Multiset[]).should be_false

    Multiset[].subset?(Multiset[1]).should be_true
    Multiset[].subset?(Multiset[]).should be_true
  end

  it "should return true if the set is a proper subset of the given set" do
    set = Multiset[1, 2, 3]

    lambda { set.proper_subset?() }.should raise_error
    lambda { set.proper_subset?(2) }.should raise_error
    lambda { set.proper_subset?([2]) }.should raise_error

    set.proper_subset?(Multiset[1, 2, 3, 4]).should be_true
    set.proper_subset?(Multiset[1, 2, 3]).should be_false
    set.proper_subset?(Multiset[1, 2]).should be_false
    set.proper_subset?(Multiset[]).should be_false

    Multiset[].proper_subset?(Multiset[]).should be_false
  end

  it "should add the given object to the set and return self" do
    set = Multiset[1, 2, 3]

    ret = set.add(2)
    set.should equal(ret)
    set.should eql(Multiset[1, 2, 2, 3])

    ret = set.add(4)
    set.should equal(ret)
    set.should eql(Multiset[1, 2, 2, 3, 4])
  end

  it "should delete the given object from the set and return self" do
    set = Multiset[1, 2, 3]

    ret = set.delete(4)
    set.should equal(ret)
    set.should eql(Multiset[1, 2, 3])

    ret = set.delete(2)
    set.should eql(ret)
    set.should eql(Multiset[1, 3])
  end

  it "should delete every element of the set for which block evaluates to true, and return self" do
    set = Multiset.new(1..10)
    ret = set.delete_if { |i| i > 10 }
    set.should equal(ret)
    set.should eql(Multiset.new(1..10))

    set = Multiset.new(1..10)
    ret = set.delete_if { |i| i % 3 == 0 }
    set.should equal(ret)
    set.should eql(Multiset[1, 2, 4, 5, 7, 8, 10])
  end

  it "should deletes every element of the set for which block evaluates to true but return nil if no changes were made" do
    set = Multiset.new(1..10)

    ret = set.reject! { |i| i > 10 }
    ret.should be_nil
    set.should eql(Multiset.new(1..10))

    ret = set.reject! { |i| i % 3 == 0 }
    set.should equal(ret)
    set.should eql(Multiset[1, 2, 4, 5, 7, 8, 10])
  end

  it "should merge the elements of the given enumerable object to the set and return self" do
    set = Multiset[1, 2, 3]

    ret = set.merge([2, 4, 6])
    set.should equal(ret)
    set.should eql(Multiset[1, 2, 2, 3, 4, 6])
  end

  it "should delete every element that appears in the given enumerable object and return self" do
    set = Multiset[1, 2, 3]

    ret = set.subtract([2, 4, 6])
    set.should equal(ret)
    set.should eql(Multiset[1, 3])
  end

  it "should return a new set built by merging the set and the elements of the given enumerable object" do
    set = Multiset[1, 2, 3]

    ret = set + [2, 4, 6]
    set.should_not equal(ret)
    ret.should eql(Multiset[1, 2, 2, 3, 4, 6])
  end

  it "should return a new set built by duplicating the set, removing every element that appears in the given enumerable object" do
    set = Multiset[1, 2, 3]

    ret = set - [2, 4, 6]
    set.should_not equal(ret)
    ret.should eql(Multiset[1, 3])
  end

  it "should return a new set containing elements common to the set and the given enumerable object" do
    set = Multiset[1, 2, 3, 4]

    ret = set & [2, 4, 6]
    set.should_not equal(ret)
    ret.should eql(Multiset[2, 4])
  end

  it "should return a new set containing elements exclusive between the set and the given enumerable object" do
    set = Multiset[1, 2, 3, 4]
    ret = set ^ [2, 4, 5]
    set.should_not equal(ret)
    ret.should eql(Multiset[1, 3, 5])
  end
end

shared_examples_for Set, "with inital values [1, 2]" do
  it "should add element to set" do
    @set.add("foo")

    @set.include?(1).should be_true
    @set.include?(2).should be_true
    @set.include?("foo").should be_true
  end

  it "should merge elements into the set" do
    @set.merge([2, 6])

    @set.include?(1).should be_true
    @set.include?(2).should be_true
    @set.include?(2).should be_true
    @set.include?(6).should be_true
  end

  it "should iterate over all the values in the set" do
    a = []
    @set.each { |o| a << o }
    a.should eql([1, 2])
  end

  it "should convert to an array" do
    @set.to_a.should eql([1, 2])
  end

  it "should convert to a set" do
    @set.to_set.to_a.should eql([1, 2])
  end
end
