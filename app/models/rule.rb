class Rule < ApplicationRecord
  belongs_to :user

  include HTTParty
  @currencies_url = "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies.json"

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
    response.keys
  end

  def self.minus_one_date(date)
    raise "[minus_one_date] Date should not be nil" if date.nil?

    previous_date = DateTime.parse(date) - 1.day
    previous_date.strftime("%Y-%m-%d")
  end

  def self.get_prices_for_currency(currency)
    latest = HTTParty.get(latest_price_url(currency))
    yesterday = minus_one_date(latest["date"])
    yesterdays = HTTParty.get(price_url_for(currency, yesterday))
    { latest: latest[currency], yesterday: yesterday[currency]}
  end

  def triggered?(rate)
    case (comparison_operator)
    when "<"
      rate < multiplier
    when ">"
      rate > multiplier
    when "<="
      rate <= multiplier
    when ">="
      rate >= multiplier
    else
      puts "Invalid operator #{comparison_operator}"
    end
  end

  def is_alerting?(latest_rate, previous_rate)
    is_triggered = triggered?(latest_rate)
    was_triggered = triggered?(previous_rate)
    is_triggered && !was_triggered
  end

  def self.get_alerts_for_currency(currency)
    alerts_for_currency = []

    rules = Rule.where(base_currency: currency)
    return alerts_for_currency if rules.empty?

    latest_price_response = HTTParty.get(latest_price_url(currency))
    latest_date = latest_price_response["date"]
    latest_prices = latest_price_response[currency]

    previous_date = minus_one_date(latest_date)
    previous_prices = HTTParty.get(price_url_for(currency, previous_date))[currency]    

    rules.each do |rule|
      if rule.is_alerting?(latest_prices[rule.quote_currency],
                           previous_prices[rule.quote_currency])
        alerts_for_currency << rule
      end
    end

    alerts_for_currency
  end

  def self.alerting
    all_alerts = []
    # List of all curenciesg
    currencies = list_currencies
    currencies.each do |currency|
      alerts_for_currency = get_alerts_for_currency(currency)
      all_alerts += alerts_for_currency
    end 

    puts "Alerting rules:\n\n #{alerts.pluck(:id).join(", ")}"
    all_alerts
  end
end
