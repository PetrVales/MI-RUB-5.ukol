require 'rspec'
require 'net/http'
require_relative '../lib/bank.rb'
require_relative '../lib/czech_national_bank.rb'
require_relative '../lib/money.rb'

describe "Bank" do

  NAME = 'Name'
  SURNAME = 'Surname'

  before(:each) do
    Net::HTTP.stub!(:get).and_return(File.read "./resources/spec/denni_kurz.txt")
    @bank = Bank.new(Czech_National_Bank.new)
  end

  it "should create accounts" do
    accountNumber = @bank.createBankAccount(NAME, SURNAME)
    @bank.getAccountBalance(accountNumber).should eq Money.new(0, "CZK")
  end

  it "should add 100 CZK to account" do
    accountNumber = @bank.createBankAccount(NAME, SURNAME)
    @bank.addMoney(accountNumber, Money.new(100, :CZK))
    @bank.getAccountBalance(accountNumber).should eq Money.new(100, "CZK")
  end

  it "should transfer 50 CZK from one account to another" do
    fromAccountNumber = @bank.createBankAccount(NAME, SURNAME)
    toAccountNumber = @bank.createBankAccount(NAME, SURNAME)
    @bank.addMoney(fromAccountNumber, Money.new(100, :CZK))
    @bank.transferMoney(fromAccountNumber, toAccountNumber, Money.new(50, :CZK))
    @bank.getAccountBalance(fromAccountNumber).should eq Money.new(50, :CZK)
    @bank.getAccountBalance(toAccountNumber).should eq Money.new(50, :CZK)
  end

  it "should get statement of transactions for account" do
    accountNumber = @bank.createBankAccount(NAME, SURNAME)
    @bank.getStatementOfTransactions(accountNumber).should eq ['Ucet zalozen, zustatek = 0 CZK']
    @bank.addMoney(accountNumber, Money.new(100, :CZK))
    @bank.getStatementOfTransactions(accountNumber).should eq ['Ucet zalozen, zustatek = 0 CZK', 'Na ucet vlozeno 100 CZK']
    secondAccountNumber = @bank.createBankAccount(NAME, SURNAME)
    @bank.transferMoney(accountNumber, secondAccountNumber, Money.new(50, :CZK))
    @bank.getStatementOfTransactions(accountNumber).should eq ['Ucet zalozen, zustatek = 0 CZK', 'Na ucet vlozeno 100 CZK', "50 CZK prevedeno na ucet #{secondAccountNumber}"]
    @bank.getStatementOfTransactions(secondAccountNumber).should eq ['Ucet zalozen, zustatek = 0 CZK', "50 CZK pripsano z ucetu #{accountNumber}"]
  end

  it "should exchange from 25.66 CZK to 1 EUR" do
    @bank.exchange(Money.new(25.660, :CZK), :EUR).should eq Money.new(1, :EUR)
  end

  it "should exchange from 1 EUR to 25.66 CZK" do
    @bank.exchange(Money.new(1, :EUR), :CZK).should eq Money.new(25.660, :CZK)
  end

  it "should exchange from CZK to CZK" do
    @bank.exchange(Money.new(1, :CZK), :CZK).should eq Money.new(1, :CZK)
  end

  it "should raise error when exchange from EUR to USD requested" do
    expect { @bank.exchange(Money.new(1, :EUR), :USD) }.to raise_error(ArgumentError)
  end

  it "should add 100 EUR to account" do
    accountNumber = @bank.createBankAccount(NAME, SURNAME)
    @bank.addMoney(accountNumber, Money.new(100, :EUR))
    @bank.getAccountBalance(accountNumber).should eq Money.new(2566.0, "CZK")
  end

  it "should transfer 100 EUR from one account to another" do
    fromAccountNumber = @bank.createBankAccount(NAME, SURNAME)
    toAccountNumber = @bank.createBankAccount(NAME, SURNAME)
    @bank.addMoney(fromAccountNumber, Money.new(2566.0, :CZK))
    @bank.transferMoney(fromAccountNumber, toAccountNumber, Money.new(100, :EUR))
    @bank.getAccountBalance(fromAccountNumber).should eq Money.new(0, :CZK)
    @bank.getAccountBalance(toAccountNumber).should eq Money.new(2566.0, :CZK)
  end

  it "should exchange from 8.669 CZK to 100 HUF" do
    @bank.exchange(Money.new(8.669, :CZK), :HUF).should eq Money.new(100, :HUF)
  end

  it "should exchange from 100 HUF to 8.669 CZK" do
    @bank.exchange(Money.new(100, :HUF), :CZK).should eq Money.new(8.669, :CZK)
  end

end
