require "rspec"
require "net/http"
require_relative "../lib/czech_national_bank.rb"

describe "Czech national bank" do

  CZK_USD_RATING = 33.333
  CZK_EUR_RATING = 25.660
  KNOWN_CURRENCY_CODES = (%w(AUD BRL BGN CNY DKK EUR PHP HKD HRK INR IDR ILS JPY ZAR KRW CAD LTL LVL HUF MYR MXN XDR NOK
                          NZD PLN RON RUB SGD SEK CHF THB TRY USD GBP)).map {|x| x.to_sym}
  UNKNOWN_CURRENCY_CODE = "BLABLA"
  USD_CURRENCY_CODE = "USD"
  EUR_CURRENCY_CODE = "EUR"
  HUF_CURRENCY_CODE = "HUF"

  before(:each) do
    Net::HTTP.stub!(:get).and_return(File.read "./resources/spec/denni_kurz.txt")
    @czech_national_bank = Czech_National_Bank.new
  end

  it "should return exchange rate CZK to USD" do
    @czech_national_bank.getExchangeRateFrom(USD_CURRENCY_CODE).should eq CZK_USD_RATING
  end

  it "should return exchange rate CZK to EUR" do
    @czech_national_bank.getExchangeRateFrom(EUR_CURRENCY_CODE).should eq CZK_EUR_RATING
  end

  it "should return exchange rate EUR to CZK" do
    @czech_national_bank.getExchangeRateTo(EUR_CURRENCY_CODE).should eq (1.0 / CZK_EUR_RATING)
  end

  it "should return units of EUR" do
    @czech_national_bank.getUnits(EUR_CURRENCY_CODE).should eq 1
  end

  it "should return units of HUF" do
    @czech_national_bank.getUnits(HUF_CURRENCY_CODE).should eq 100
  end

  it "should raise exception for unknown currency" do
    expect { @czech_national_bank.getExchangeRateFrom(UNKNOWN_CURRENCY_CODE) }.to raise_error(ArgumentError)
  end

  it "should return list of known currencies" do
    @czech_national_bank.getKnownCurrencies.should eq KNOWN_CURRENCY_CODES
  end

end
