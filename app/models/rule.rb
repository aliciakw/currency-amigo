class Rule < ApplicationRecord
  belongs_to :user

  include HTTParty
  @currencies_url = "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies.json"
  @currencies_list = nil

  def self.price_url_for(currency, date) #YYYY-MM-DD
    "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@#{date}/v1/currencies/#{currency}.json"
  end

  def self.latest_price_url(currency)
    price_url_for(currency, "latest")
  end


  # Every day at midnight
  # List of all currencies https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies.json
  # Request all currencies for today
  # For each (e.g EUR)
  # https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/eur.json
  # Compare with rates from (date from prev payload - 1 day)
  # https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@2024-03-06/v1/currencies/eur.json

  # HandleCurrencyRateChanged(base_currency)
  # Skip if rate did not change
  # Get all AlertThreshholds that are relevant
  # For each Threshhold, determine if it has been past (comparing with past rate)
  # If so, email all verified users

  def self.list_currencies
    response = HTTParty.get(@currencies_url)
    puts response.body
  end

  def self.minus_one_date(date)
    previous_date = DateTime.parse(date) - 1.day
    previous_date.strftime("%Y-%m-%d")
  end

  def self.get_prices_for_currency(currency)
    latest = HTTParty.get(latest_price_url(currency))
    yesterday = minus_one_date(latest["date"])
    yesterdays = HTTParty.get(price_url_for(currency, yesterday))
    { latest: latest, yesterday: yesterday}
  end

  def self.get_alerts
    # List of all curencies
    @currencies_list = list_currencies
   get_prices_for_currency( @currencies_list["eur"])
    # For each currency
    # @currencies_list.each do |currency|
    #   current_price = HTTParty.get(latest_price_url(currency))
    #   puts current_price
    # end

  end
end
