require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))
require File.expand_path(File.join(File.dirname(__FILE__), '../../lib/rbench/reporter'))

describe RBench::Reporter::Runner, "#add_reports" do

  before(:each) do
    @runner = RBench::Runner.new(42)
    @passed = []
    @block = lambda { |*args| @passed << args }
  end

  it "attempts to use a block passed" do
    @runner.add_reports(%w(one #1), %w(two #2), &@block)
    @passed.should == [[@runner, 'one', '#1'], [@runner, 'two', '#2']]
  end

  it "fallbacks to default block" do
    @runner.default(&@block)
    @runner.add_reports(%w(one #1), %w(two #2))
    @passed.should == [[@runner, 'one', '#1'], [@runner, 'two', '#2']]
  end

end

describe RBench::Reporter::Runner, "#grouped" do

  before(:each) do
    @runner = RBench::Runner.new(42)
    @passed = []
    @block = lambda { |*args| @passed << args }
  end

  before(:each) do
    @group = RBench::Group.new(@runner,'spec')
    RBench::Group.should_receive(:new).with(@runner, 'spec', nil).and_return(@group)
  end

  it "creates a group" do
    @runner.grouped('spec', %w(one #1), %w(two #2), &@block)
  end

  it "attempts to use a block passed" do
    @runner.grouped('spec', %w(one #1), %w(two #2), &@block)
    @passed.should == [[@group, 'one', '#1'], [@group, 'two', '#2']]
  end

  it "fallbacks to default block" do
    @runner.default(&@block)
    @runner.grouped('spec', %w(one #1), %w(two #2), &@block)
    @passed.should == [[@group, 'one', '#1'], [@group, 'two', '#2']]
  end

end

describe RBench::Reporter::Group, "#add_reports" do

  before(:each) do
    @runner = RBench::Runner.new(42)
    @group = RBench::Group.new(@runner,'spec')
    @passed = []
    @block = lambda { |*args| @passed << args }
  end

  it "attempts to use a block passed" do
    @group.add_reports(%w(one #1), %w(two #2), &@block)
    @passed.should == [[@group, 'one', '#1'], [@group, 'two', '#2']]
  end

  it "fallbacks to default block" do
    @group.default(&@block)
    @group.add_reports(%w(one #1), %w(two #2))
    @passed.should == [[@group, 'one', '#1'], [@group, 'two', '#2']]
  end

end
