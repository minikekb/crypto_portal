class PagesController < ApplicationController
  def dashboard
    client = BybitApi.new(ENV["BYBIT_API_KEY"], ENV["BYBIT_SECRET_KEY"])

    tickers_response = client.fetch_tickers("BTCUSDT", "inverse")
    @price = tickers_response["result"]["list"].first["lastPrice"]

    wallet_response = client.wallet_balance
    @wallet_balance = wallet_response["result"]["list"].first["totalEquity"]
  end
  def create_order
    client = BybitApi.new(ENV["BYBIT_API_KEY"], ENV["BYBIT_SECRET_KEY"])

    # Создаём ордер
    order_response = client.create_order("DOGEUSDT", "Buy", "Market", "100")

    if order_response["result"]
      redirect_to dashboard_path, notice: "Ордер успешно создан!"
    else
      redirect_to dashboard_path, alert: "Не удалось создать ордер."
    end
  end
end
