require "rspec"
require_relative "../lib/money.rb"

describe "Money" do

  it "should initialize money of given value and currency" do
    money = Money.new(1000, "USD")
    money.amount.should eq 1000
    money.currency.should eq :USD
  end

  it "should equal for same amount and currency" do
    Money.new(1000, "USD").should == Money.new(1000, "USD")
  end

  it "should not equal for different amount" do
    Money.new(500, "USD").should_not == Money.new(1000, "USD")
  end

  it "should not equal for different currency" do
     Money.new(1000, "CZK").should_not == Money.new(1000, "USD")
  end

  it "should add" do
    (Money.new(1000, "USD") + Money.new(500, "USD")).should eq Money.new(1500, "USD")
  end

  it "should raise exception when two different currencies are added" do
    expect { Money.new(1000, "USD") + Money.new(500, "CZK") }.to raise_error(ArgumentError)
  end

  it "should subtract" do
    (Money.new(1000, "USD") - Money.new(200, "USD")).should eq Money.new(800, "USD")
  end

  it "should raise exception when two different currencies are subtracted" do
    expect { Money.new(1000, "USD") - Money.new(500, "CZK") }.to raise_error(ArgumentError)
  end

  it "should be created from String" do
    "500 USD".to_money.should == Money.new(500, "USD")
  end

  it "should be created from Integer" do
    500.to_money.should == Money.new(500, "CZK")
  end

  it "should compute 150.0 CZK + 50" do
    ("150.0 CZK".to_money + 50).should == Money.new(200, :CZK)
  end

end
