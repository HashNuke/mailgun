require 'spec_helper'

describe Multiset do
  it_should_behave_like "Set"

  it "should return the multiplicity of the element" do
    set = Multiset.new([:a, :a, :b, :b, :b, :c])
    expect(set.multiplicity(:a)).to eql(2)
    expect(set.multiplicity(:b)).to eql(3)
    expect(set.multiplicity(:c)).to eql(1)
  end

  it "should return the cardinality of the set" do
    set = Multiset.new([:a, :a, :b, :b, :b, :c])
    expect(set.cardinality).to eql(6)
  end

  it "should be eql" do
    s1 = Multiset.new([:a, :b])
    s2 = Multiset.new([:b, :a])
    expect(s1).to eql(s2)

    s1 = Multiset.new([:a, :a])
    s2 = Multiset.new([:a])
    expect(s1).to_not eql(s2)
  end

  it "should replace the contents of the set" do
    set = Multiset[:a, :b, :b, :c]
    ret = set.replace(Multiset[:a, :a, :b, :b, :b, :c])

    expect(set).to equal(ret)
    expect(set).to eql(Multiset[:a, :a, :b, :b, :b, :c])

    set = Multiset[:a, :b, :b, :c]
    ret = set.replace([:a, :a, :b, :b, :b, :c])

    expect(set).to equal(ret)
    expect(set).to eql(Multiset[:a, :a, :b, :b, :b, :c])
  end

  it "should return true if the set is a superset of the given set" do
    set = Multiset[1, 2, 2, 3]

    expect(set.superset?(Multiset[])).to be_true
    expect(set.superset?(Multiset[1, 2])).to be_true
    expect(set.superset?(Multiset[1, 2, 3])).to be_true
    expect(set.superset?(Multiset[1, 2, 2, 3])).to be_true
    expect(set.superset?(Multiset[1, 2, 2, 2])).to be_false
    expect(set.superset?(Multiset[1, 2, 3, 4])).to be_false
    expect(set.superset?(Multiset[1, 4])).to be_false
  end

  it "should return true if the set is a proper superset of the given set" do
    set = Multiset[1, 2, 2, 3, 3]

    expect(set.proper_superset?(Multiset[])).to be_true
    expect(set.proper_superset?(Multiset[1, 2])).to be_true
    expect(set.proper_superset?(Multiset[1, 2, 3])).to be_true
    expect(set.proper_superset?(Multiset[1, 2, 2, 3, 3])).to be_false
    expect(set.proper_superset?(Multiset[1, 2, 2, 2])).to be_false
    expect(set.proper_superset?(Multiset[1, 2, 3, 4])).to be_false
    expect(set.proper_superset?(Multiset[1, 4])).to be_false
  end

  it "should return true if the set is a subset of the given set" do
    set = Multiset[1, 2, 2, 3]

    expect(set.subset?(Multiset[1, 2, 2, 3, 4])).to be_true
    expect(set.subset?(Multiset[1, 2, 2, 3, 3])).to be_true
    expect(set.subset?(Multiset[1, 2, 2, 3])).to be_true
    expect(set.subset?(Multiset[1, 2, 3])).to be_false
    expect(set.subset?(Multiset[1, 2, 2])).to be_false
    expect(set.subset?(Multiset[1, 2, 3])).to be_false
    expect(set.subset?(Multiset[])).to be_false
  end

  it "should return true if the set is a proper subset of the given set" do
    set = Multiset[1, 2, 2, 3, 3]

    expect(set.proper_subset?(Multiset[1, 2, 2, 3, 3, 4])).to be_true
    expect(set.proper_subset?(Multiset[1, 2, 2, 3, 3])).to be_false
    expect(set.proper_subset?(Multiset[1, 2, 3])).to be_false
    expect(set.proper_subset?(Multiset[1, 2, 2])).to be_false
    expect(set.proper_subset?(Multiset[1, 2, 3])).to be_false
    expect(set.proper_subset?(Multiset[])).to be_false
  end

  it "should delete the objects from the set and return self" do
    set = Multiset[1, 2, 2, 3]

    ret = set.delete(4)
    expect(set).to equal(ret)
    expect(set).to eql(Multiset[1, 2, 2, 3])

    ret = set.delete(2)
    expect(set).to eql(ret)
    expect(set).to eql(Multiset[1, 3])
  end

  it "should delete the number objects from the set and return self" do
    set = Multiset[1, 2, 2, 3]

    ret = set.delete(2, 1)
    expect(set).to eql(ret)
    expect(set).to eql(Multiset[1, 2, 3])
  end

  it "should merge the elements of the given enumerable object to the set and return self" do
    set = Multiset[1, 2, 3]
    ret = set.merge([2, 4, 5])
    expect(set).to equal(ret)
    expect(set).to eql(Multiset[1, 2, 2, 3, 4, 5])

    set = Multiset[1, 2, 3]
    ret = set.merge(Multiset[2, 4, 5])
    expect(set).to equal(ret)
    expect(set).to eql(Multiset[1, 2, 2, 3, 4, 5])
  end

  it "should delete every element that appears in the given enumerable object and return self" do
    set = Multiset[1, 2, 2, 3]
    ret = set.subtract([2, 4, 6])
    expect(set).to equal(ret)
    expect(set).to eql(Multiset[1, 2, 3])
  end

  it "should return a new set containing elements common to the set and the given enumerable object" do
    set = Multiset[1, 2, 2, 3, 4]

    ret = set & [2, 2, 4, 5]
    expect(set).to_not equal(ret)
    expect(ret).to eql(Multiset[2, 2, 4])

    set = Multiset[1, 2, 3]

    ret = set & [1, 2, 2, 2]
    expect(set).to_not equal(ret)
    expect(ret).to eql(Multiset[1, 2])
  end

  it "should return a new set containing elements exclusive between the set and the given enumerable object" do
    set = Multiset[1, 2, 3, 4, 5]
    ret = set ^ [2, 4, 5, 5]
    expect(set).to_not equal(ret)
    expect(ret).to eql(Multiset[1, 3, 5])

    set = Multiset[1, 2, 4, 5, 5]
    ret = set ^ [2, 3, 4, 5]
    expect(set).to_not equal(ret)
    expect(ret).to eql(Multiset[1, 3, 5])
  end

  it "should marshal set" do
    set = Multiset[1, 2, 3, 4, 5]
    data = Marshal.dump(set)
    expect(Marshal.load(data)).to eql(set)
  end

  it "should dump yaml" do
    require 'yaml'

    set = Multiset[1, 2, 3, 4, 5]
    data = YAML.dump(set)
    expect(YAML.load(data)).to eql(set)
  end
end

describe Multiset, "with inital values" do
  it_should_behave_like "Set with inital values [1, 2]"

  before do
    @set = Multiset.new([1, 2])
  end

  it "should return the multiplicity of the element" do
    expect(@set.multiplicity(1)).to eql(1)
    expect(@set.multiplicity(2)).to eql(1)
  end

  it "should return the cardinality of the set" do
    expect(@set.cardinality).to eql(2)
  end
end
