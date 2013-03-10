class Czech_National_Bank

  def initialize
    uri = URI('http://www.cnb.cz/cs/financni_trhy/devizovy_trh/kurzy_devizoveho_trhu/denni_kurz.txt')
    lines = Net::HTTP.get(uri).split("\n")
    @rates = Hash.new
    for i in 2..(lines.length - 1)
      line = lines[i].split('|')
      @rates[line[3].to_sym] = [line[4].sub(',', '.').to_f, line[2].to_i]
    end
  end

  def getExchangeRateFrom(currency)
    @rates[checkCurrencyCode(currency)][0]
  end

  def getExchangeRateTo(currency)
    1.0 / getExchangeRateFrom(currency)
  end

  def getUnits(currency)
    @rates[checkCurrencyCode(currency)][1]
  end

  def getKnownCurrencies
    @rates.keys
  end

  private
  def checkCurrencyCode(code)
    if not @rates.has_key?(code.to_sym) then
      raise ArgumentError.new('Unknown currency code')
    else
      code.to_sym
    end
  end
end
