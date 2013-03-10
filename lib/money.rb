class Money
  def initialize(amount, currency)
    @amount = amount
    @currency = currency.to_sym
  end

  def amount
    @amount
  end

  def currency
    @currency
  end

  def ==(money)
    @amount == money.amount and @currency.to_s == money.currency.to_s
  end

  def +(param)
    money = toMoney(param)
    checkCurrencies(money)
    Money.new(@amount + money.amount, @currency)
  end

  def -(param)
    money = toMoney(param)
    checkCurrencies(money)
    Money.new(@amount - money.amount, @currency)
  end

  def to_money
    self
  end

  private
  def checkCurrencies(money)
    if @currency.to_s != money.currency.to_s then
      raise ArgumentError.new("Currencies must be same")
    end
  end
  def toMoney(money)
    if money.class.method_defined? :to_money then
      money.to_money
    else
      raise ArgumentError.new("Can't be cast to money")
    end
  end

end

class String
  def to_money
    split = self.split(" ")
    Money.new(split[0].to_f, split[1])
  end
end

class Integer
  def to_money
    Money.new(self, :CZK)
  end
end

class Float
  def to_money
    Money.new(self, :CZK)
  end
end
