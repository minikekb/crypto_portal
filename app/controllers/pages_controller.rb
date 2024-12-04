class PagesController < ApplicationController
  def dashboard
    client = BybitApi.new(ENV["BYBIT_API_KEY"], ENV["BYBIT_SECRET_KEY"])

    tickers_response = client.fetch_tickers("BTCUSDT", "inverse")
    @price = tickers_response["result"]["list"].first["lastPrice"]

    wallet_response = client.wallet_balance
    @wallet_balance = wallet_response["result"]["list"].first["totalEquity"]

    order_response = client.create_order("ETHUSDT", "Buy", "Market", "1")
    @place_order = order_response
  end
end
