class PagesController < ApplicationController
  def dashboard
    client = BybitApi.new(ENV["BYBIT_API_KEY"], ENV["BYBIT_SECRET_KEY"])

    end_point = "/v5/market/tickers"
    method = "GET"
    payload = "category=inverse&symbol=BTCUSDT"

    # Отправляем запрос и получаем ответ от Bybit
    response = client.http_request(end_point, method, payload)

    # Убедимся, что response - строка
    response_body = response.is_a?(Net::HTTPResponse) ? response : response

    # Преобразуем JSON ответ в объект Ruby
    api_response = JSON.parse(response_body)

    wallet_end_point = "/v5/account/wallet-balance"
    wallet_method = "GET"
    wallet_payload = "accountType=UNIFIED&coin=BTC"

    # Отправляем запрос и получаем ответ от Bybit
    wallet_response = client.http_request(wallet_end_point, wallet_method, wallet_payload)

    # Убедимся, что response - строка
    wallet_response_body = wallet_response.is_a?(Net::HTTPResponse) ? wallet_response : wallet_response

    # Преобразуем JSON ответ в объект Ruby
    wallet_api_response = JSON.parse(wallet_response_body)

    @price = api_response["result"]["list"].first["lastPrice"]
    @wallet_balance = wallet_api_response["result"]["list"].first["totalEquity"]
  end
end
