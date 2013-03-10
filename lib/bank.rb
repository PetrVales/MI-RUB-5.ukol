require_relative 'money.rb'
require_relative 'czech_national_bank.rb'

class Bank
  def initialize(czb)
    @czech_national_bank = czb
    @accounts = Hash.new
    @nextAccountNumber = 11112233359
  end

  def createBankAccount(name, surname)
    accountNumber = getNewAccountNumber
    account = Account.new(accountNumber, name, surname)
    @accounts[accountNumber] = account
    account.log 'Ucet zalozen, zustatek = 0 CZK'
    accountNumber
  end

  def getAccountBalance(accountNumber)
    @accounts[accountNumber].balance
  end

  def addMoney(accountNumber, money)
    money = exchange(money, :CZK)
    @accounts[accountNumber].addMoney(money)
    @accounts[accountNumber].log "Na ucet vlozeno #{money.amount} CZK"
  end

  def transferMoney(fromAccountNumber, toAccountNumber, money)
    money = exchange(money, :CZK)
    @accounts[fromAccountNumber].subMoney(money)
    @accounts[fromAccountNumber].log "#{money.amount} CZK prevedeno na ucet #{toAccountNumber}"
    @accounts[toAccountNumber].addMoney(money)
    @accounts[toAccountNumber].log "#{money.amount} CZK pripsano z ucetu #{fromAccountNumber}"
  end

  def getStatementOfTransactions(accountNumber)
    @accounts[accountNumber].getLog
  end

  def exchange(money, currency)
    if money.currency == currency then
      money
    elsif money.currency == :CZK then
      Money.new(money.amount * @czech_national_bank.getExchangeRateTo(currency) * @czech_national_bank.getUnits(currency), currency)
    elsif currency == :CZK then
      Money.new(money.amount * @czech_national_bank.getExchangeRateFrom(money.currency) / @czech_national_bank.getUnits(money.currency), currency)
    else
      raise ArgumentError.new("Can exchange only from and to CZK")
    end
  end

  private
  def getNewAccountNumber
    @nextAccountNumber = @nextAccountNumber + 1
    (@nextAccountNumber - 1).to_s
  end
end

class Account
  def initialize(accountNumber, name, surname)
    @accountNumber = accountNumber
    @name = name
    @surname = surname
    @balance = Money.new(0, :CZK)
    @log = []
  end
  def account_number
    @accountNumber
  end
  def name
    @name
  end
  def surname
    @surname
  end
  def balance
    @balance
  end
  def addMoney(money)
    @balance = @balance + money
  end
  def subMoney(money)
    @balance = @balance - money
  end
  def log(message)
    @log.push(message)
  end
  def getLog
    @log
  end
end
