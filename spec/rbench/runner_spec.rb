require 'pathname'
require Pathname(__FILE__).dirname.join('../spec_helper').expand_path

describe RBench::Runner, "#group" do

  before(:each) do
    @runner = RBench::Runner.new(0)
  end

  it "attemts to create a new group (proxy to the Rbench::Group.new)" do
    block = lambda { :nope }
    RBench::Group.should_receive(:new).with(@runner, 'spec', &block)
    @runner.group('spec', 42, &block)
  end

end

describe RBench::Runner, "#report" do

  before(:each) do
    @runner = RBench::Runner.new(42)
  end

  it "attempts to attach a new report to the last open group" do
    group = RBench::Group.new(@runner, 'spec')
    RBench::Group.should_receive(:new).with(@runner, 'spec', nil).and_return(group)
    @runner.group('spec'){}
    @runner.report('spec'){}
    group.items.size.should == 1
    report = group.items.first
    report.name.should == 'spec'
  end

  it "creates an anonymous group otherwise" do
    group = RBench::Group.new(@runner, nil)
    RBench::Group.should_receive(:new).with(@runner, nil, nil).and_return(group)
    @runner.report('spec'){}
    group.items.size.should == 1
    report = group.items.first
    report.name.should == 'spec'
  end

end