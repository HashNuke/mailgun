require 'spec_helper'

describe Multiset do
  it_should_behave_like "Set"

  it "should return the multiplicity of the element" do
    set = Multiset.new([:a, :a, :b, :b, :b, :c])
    set.multiplicity(:a).should eql(2)
    set.multiplicity(:b).should eql(3)
    set.multiplicity(:c).should eql(1)
  end

  it "should return the cardinality of the set" do
    set = Multiset.new([:a, :a, :b, :b, :b, :c])
    set.cardinality.should eql(6)
  end

  it "should be eql" do
    s1 = Multiset.new([:a, :b])
    s2 = Multiset.new([:b, :a])
    s1.should eql(s2)

    s1 = Multiset.new([:a, :a])
    s2 = Multiset.new([:a])
    s1.should_not eql(s2)
  end

  it "should replace the contents of the set" do
    set = Multiset[:a, :b, :b, :c]
    ret = set.replace(Multiset[:a, :a, :b, :b, :b, :c])

    set.should equal(ret)
    set.should eql(Multiset[:a, :a, :b, :b, :b, :c])

    set = Multiset[:a, :b, :b, :c]
    ret = set.replace([:a, :a, :b, :b, :b, :c])

    set.should equal(ret)
    set.should eql(Multiset[:a, :a, :b, :b, :b, :c])
  end

  it "should return true if the set is a superset of the given set" do
    set = Multiset[1, 2, 2, 3]

    set.superset?(Multiset[]).should be_true
    set.superset?(Multiset[1, 2]).should be_true
    set.superset?(Multiset[1, 2, 3]).should be_true
    set.superset?(Multiset[1, 2, 2, 3]).should be_true
    set.superset?(Multiset[1, 2, 2, 2]).should be_false
    set.superset?(Multiset[1, 2, 3, 4]).should be_false
    set.superset?(Multiset[1, 4]).should be_false
  end

  it "should return true if the set is a proper superset of the given set" do
    set = Multiset[1, 2, 2, 3, 3]

    set.proper_superset?(Multiset[]).should be_true
    set.proper_superset?(Multiset[1, 2]).should be_true
    set.proper_superset?(Multiset[1, 2, 3]).should be_true
    set.proper_superset?(Multiset[1, 2, 2, 3, 3]).should be_false
    set.proper_superset?(Multiset[1, 2, 2, 2]).should be_false
    set.proper_superset?(Multiset[1, 2, 3, 4]).should be_false
    set.proper_superset?(Multiset[1, 4]).should be_false
  end

  it "should return true if the set is a subset of the given set" do
    set = Multiset[1, 2, 2, 3]

    set.subset?(Multiset[1, 2, 2, 3, 4]).should be_true
    set.subset?(Multiset[1, 2, 2, 3, 3]).should be_true
    set.subset?(Multiset[1, 2, 2, 3]).should be_true
    set.subset?(Multiset[1, 2, 3]).should be_false
    set.subset?(Multiset[1, 2, 2]).should be_false
    set.subset?(Multiset[1, 2, 3]).should be_false
    set.subset?(Multiset[]).should be_false
  end

  it "should return true if the set is a proper subset of the given set" do
    set = Multiset[1, 2, 2, 3, 3]

    set.proper_subset?(Multiset[1, 2, 2, 3, 3, 4]).should be_true
    set.proper_subset?(Multiset[1, 2, 2, 3, 3]).should be_false
    set.proper_subset?(Multiset[1, 2, 3]).should be_false
    set.proper_subset?(Multiset[1, 2, 2]).should be_false
    set.proper_subset?(Multiset[1, 2, 3]).should be_false
    set.proper_subset?(Multiset[]).should be_false
  end

  it "should delete the objects from the set and return self" do
    set = Multiset[1, 2, 2, 3]

    ret = set.delete(4)
    set.should equal(ret)
    set.should eql(Multiset[1, 2, 2, 3])

    ret = set.delete(2)
    set.should eql(ret)
    set.should eql(Multiset[1, 3])
  end

  it "should delete the number objects from the set and return self" do
    set = Multiset[1, 2, 2, 3]

    ret = set.delete(2, 1)
    set.should eql(ret)
    set.should eql(Multiset[1, 2, 3])
  end

  it "should merge the elements of the given enumerable object to the set and return self" do
    set = Multiset[1, 2, 3]
    ret = set.merge([2, 4, 5])
    set.should equal(ret)
    set.should eql(Multiset[1, 2, 2, 3, 4, 5])

    set = Multiset[1, 2, 3]
    ret = set.merge(Multiset[2, 4, 5])
    set.should equal(ret)
    set.should eql(Multiset[1, 2, 2, 3, 4, 5])
  end

  it "should delete every element that appears in the given enumerable object and return self" do
    set = Multiset[1, 2, 2, 3]
    ret = set.subtract([2, 4, 6])
    set.should equal(ret)
    set.should eql(Multiset[1, 2, 3])
  end

  it "should return a new set containing elements common to the set and the given enumerable object" do
    set = Multiset[1, 2, 2, 3, 4]

    ret = set & [2, 2, 4, 5]
    set.should_not equal(ret)
    ret.should eql(Multiset[2, 2, 4])

    set = Multiset[1, 2, 3]

    ret = set & [1, 2, 2, 2]
    set.should_not equal(ret)
    ret.should eql(Multiset[1, 2])
  end

  it "should return a new set containing elements exclusive between the set and the given enumerable object" do
    set = Multiset[1, 2, 3, 4, 5]
    ret = set ^ [2, 4, 5, 5]
    set.should_not equal(ret)
    ret.should eql(Multiset[1, 3, 5])

    set = Multiset[1, 2, 4, 5, 5]
    ret = set ^ [2, 3, 4, 5]
    set.should_not equal(ret)
    ret.should eql(Multiset[1, 3, 5])
  end

  it "should marshal set" do
    set = Multiset[1, 2, 3, 4, 5]
    data = Marshal.dump(set)
    Marshal.load(data).should eql(set)
  end

  it "should dump yaml" do
    require 'yaml'

    set = Multiset[1, 2, 3, 4, 5]
    data = YAML.dump(set)
    YAML.load(data).should eql(set)
  end
end

describe Multiset, "with inital values" do
  it_should_behave_like "Set with inital values [1, 2]"

  before do
    @set = Multiset.new([1, 2])
  end

  it "should return the multiplicity of the element" do
    @set.multiplicity(1).should eql(1)
    @set.multiplicity(2).should eql(1)
  end

  it "should return the cardinality of the set" do
    @set.cardinality.should eql(2)
  end
end
