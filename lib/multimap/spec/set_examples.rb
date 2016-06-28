shared_examples_for Set do
  it "should create a new set containing the given objects" do
    Multiset[]
    Multiset[nil]
    Multiset[1, 2, 3]

    expect(Multiset[].size).to eql(0)
    expect(Multiset[nil].size).to eql(1)
    expect(Multiset[[]].size).to eql(1)
    expect(Multiset[[nil]].size).to eql(1)

    set = Multiset[2, 4, 6, 4]
    expect(Multiset.new([2, 4, 6])).to_not eql(set)

    set = Multiset[2, 4, 6, 4]
    expect(Multiset.new([2, 4, 6, 4])).to eql(set)
  end

  it "should create a new set containing the elements of the given enumerable object" do
    Multiset.new()
    Multiset.new(nil)
    Multiset.new([])
    Multiset.new([1, 2])
    Multiset.new('a'..'c')

    expect(lambda { Multiset.new(false) }).to raise_error
    expect(lambda { Multiset.new(1) }).to raise_error
    expect(lambda { Multiset.new(1, 2) }).to raise_error

    expect(Multiset.new().size).to eql(0)
    expect(Multiset.new(nil).size).to eql(0)
    expect(Multiset.new([]).size).to eql(0)
    expect(Multiset.new([nil]).size).to eql(1)

    ary = [2, 4, 6, 4]
    set = Multiset.new(ary)
    ary.clear
    expect(set).to_not be_empty
    expect(set.size).to eql(4)

    ary = [1, 2, 3]

    s = Multiset.new(ary) { |o| o * 2 }
    expect([2, 4, 6]).to eql(s.sort)
  end

  it "should duplicate set" do
    set1 = Multiset[1, 2]
    set2 = set1.dup

    expect(set1).to_not equal(set2)

    expect(set1).to eql(set2)

    set1.add(3)

    expect(set1).to_not eql(set2)
  end

  it "should return the number of elements" do
    expect(Multiset[].size).to eql(0)
    expect(Multiset[1, 2].size).to eql(2)
    expect(Multiset[1, 2, 1].size).to eql(3)
  end

  it "should return true if the set contains no elements" do
    expect(Multiset[]).to be_empty
    expect(Multiset[1, 2]).to_not be_empty
  end

  it "should remove all elements and returns self" do
    set = Multiset[1, 2]
    ret = set.clear

    expect(set).to equal(ret)
    expect(set).to be_empty
  end

  it "should replaces the contents of the set with the contents of the given enumerable object and returns self" do
    set = Multiset[1, 2]
    ret = set.replace('a'..'c')

    expect(set).to equal(ret)
    expect(set).to eql(Multiset['a', 'b', 'c'])
  end

  it "should convert the set to an array" do
    set = Multiset[1, 2, 3, 2]
    ary = set.to_a

    expect(ary.sort).to eql([1, 2, 2, 3])
  end

  it "should return true if the set contains the given object" do
    set = Multiset[1, 2, 3]

    expect(set.include?(1)).to be_true
    expect(set.include?(2)).to be_true
    expect(set.include?(3)).to be_true
    expect(set.include?(0)).to be_false
    expect(set.include?(nil)).to be_false

    set = Multiset["1", nil, "2", nil, "0", "1", false]
    expect(set.include?(nil)).to be_true
    expect(set.include?(false)).to be_true
    expect(set.include?("1")).to be_true
    expect(set.include?(0)).to be_false
    expect(set.include?(true)).to be_false
  end

  it "should return true if the set is a superset of the given set" do
    set = Multiset[1, 2, 3]

    expect(lambda { set.superset?() }).to raise_error
    expect(lambda { set.superset?(2) }).to raise_error
    expect(lambda { set.superset?([2]) }).to raise_error

    expect(set.superset?(Multiset[])).to be_true
    expect(set.superset?(Multiset[1, 2])).to be_true
    expect(set.superset?(Multiset[1, 2, 3])).to be_true
    expect(set.superset?(Multiset[1, 2, 3, 4])).to be_false
    expect(set.superset?(Multiset[1, 4])).to be_false

    expect(Multiset[].superset?(Multiset[])).to be_true
  end

  it "should return true if the set is a proper superset of the given set" do
    set = Multiset[1, 2, 3]

    expect(lambda { set.proper_superset?() }).to raise_error
    expect(lambda { set.proper_superset?(2) }).to raise_error
    expect(lambda { set.proper_superset?([2]) }).to raise_error

    expect(set.proper_superset?(Multiset[])).to be_true
    expect(set.proper_superset?(Multiset[1, 2])).to be_true
    expect(set.proper_superset?(Multiset[1, 2, 3])).to be_false
    expect(set.proper_superset?(Multiset[1, 2, 3, 4])).to be_false
    expect(set.proper_superset?(Multiset[1, 4])).to be_false

    expect(Multiset[].proper_superset?(Multiset[])).to be_false
  end

  it "should return true if the set is a subset of the given set" do
    set = Multiset[1, 2, 3]

    expect(lambda { set.subset?() }).to raise_error
    expect(lambda { set.subset?(2) }).to raise_error
    expect(lambda { set.subset?([2]) }).to raise_error

    expect(set.subset?(Multiset[1, 2, 3, 4])).to be_true
    expect(set.subset?(Multiset[1, 2, 3])).to be_true
    expect(set.subset?(Multiset[1, 2])).to be_false
    expect(set.subset?(Multiset[])).to be_false

    expect(Multiset[].subset?(Multiset[1])).to be_true
    expect(Multiset[].subset?(Multiset[])).to be_true
  end

  it "should return true if the set is a proper subset of the given set" do
    set = Multiset[1, 2, 3]

    expect(lambda { set.proper_subset?() }).to raise_error
    expect(lambda { set.proper_subset?(2) }).to raise_error
    expect(lambda { set.proper_subset?([2]) }).to raise_error

    expect(set.proper_subset?(Multiset[1, 2, 3, 4])).to be_true
    expect(set.proper_subset?(Multiset[1, 2, 3])).to be_false
    expect(set.proper_subset?(Multiset[1, 2])).to be_false
    expect(set.proper_subset?(Multiset[])).to be_false

    expect(Multiset[].proper_subset?(Multiset[])).to be_false
  end

  it "should add the given object to the set and return self" do
    set = Multiset[1, 2, 3]

    ret = set.add(2)
    expect(set).to equal(ret)
    expect(set).to eql(Multiset[1, 2, 2, 3])

    ret = set.add(4)
    expect(set).to equal(ret)
    expect(set).to eql(Multiset[1, 2, 2, 3, 4])
  end

  it "should delete the given object from the set and return self" do
    set = Multiset[1, 2, 3]

    ret = set.delete(4)
    expect(set).to equal(ret)
    expect(set).to eql(Multiset[1, 2, 3])

    ret = set.delete(2)
    expect(set).to eql(ret)
    expect(set).to eql(Multiset[1, 3])
  end

  it "should delete every element of the set for which block evaluates to true, and return self" do
    set = Multiset.new(1..10)
    ret = set.delete_if { |i| i > 10 }
    expect(set).to equal(ret)
    expect(set).to eql(Multiset.new(1..10))

    set = Multiset.new(1..10)
    ret = set.delete_if { |i| i % 3 == 0 }
    expect(set).to equal(ret)
    expect(set).to eql(Multiset[1, 2, 4, 5, 7, 8, 10])
  end

  it "should deletes every element of the set for which block evaluates to true but return nil if no changes were made" do
    set = Multiset.new(1..10)

    ret = set.reject! { |i| i > 10 }
    expect(ret).to be_nil
    expect(set).to eql(Multiset.new(1..10))

    ret = set.reject! { |i| i % 3 == 0 }
    expect(set).to equal(ret)
    expect(set).to eql(Multiset[1, 2, 4, 5, 7, 8, 10])
  end

  it "should merge the elements of the given enumerable object to the set and return self" do
    set = Multiset[1, 2, 3]

    ret = set.merge([2, 4, 6])
    expect(set).to equal(ret)
    expect(set).to eql(Multiset[1, 2, 2, 3, 4, 6])
  end

  it "should delete every element that appears in the given enumerable object and return self" do
    set = Multiset[1, 2, 3]

    ret = set.subtract([2, 4, 6])
    expect(set).to equal(ret)
    expect(set).to eql(Multiset[1, 3])
  end

  it "should return a new set built by merging the set and the elements of the given enumerable object" do
    set = Multiset[1, 2, 3]

    ret = set + [2, 4, 6]
    expect(set).to_not equal(ret)
    expect(ret).to eql(Multiset[1, 2, 2, 3, 4, 6])
  end

  it "should return a new set built by duplicating the set, removing every element that appears in the given enumerable object" do
    set = Multiset[1, 2, 3]

    ret = set - [2, 4, 6]
    expect(set).to_not equal(ret)
    expect(ret).to eql(Multiset[1, 3])
  end

  it "should return a new set containing elements common to the set and the given enumerable object" do
    set = Multiset[1, 2, 3, 4]

    ret = set & [2, 4, 6]
    expect(set).to_not equal(ret)
    expect(ret).to eql(Multiset[2, 4])
  end

  it "should return a new set containing elements exclusive between the set and the given enumerable object" do
    set = Multiset[1, 2, 3, 4]
    ret = set ^ [2, 4, 5]
    expect(set).to_not equal(ret)
    expect(ret).to eql(Multiset[1, 3, 5])
  end
end

shared_examples_for Set, "with inital values [1, 2]" do
  it "should add element to set" do
    @set.add("foo")

    expect(@set.include?(1)).to be_true
    expect(@set.include?(2)).to be_true
    expect(@set.include?("foo")).to be_true
  end

  it "should merge elements into the set" do
    @set.merge([2, 6])

    expect(@set.include?(1)).to be_true
    expect(@set.include?(2)).to be_true
    expect(@set.include?(2)).to be_true
    expect(@set.include?(6)).to be_true
  end

  it "should iterate over all the values in the set" do
    a = []
    @set.each { |o| a << o }
    expect(a).to eql([1, 2])
  end

  it "should convert to an array" do
    expect(@set.to_a).to eql([1, 2])
  end

  it "should convert to a set" do
    expect(@set.to_set.to_a).to eql([1, 2])
  end
end
