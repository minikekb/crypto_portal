class PagesController < ApplicationController
  def dashboard
    client = BybitApi.new

    end_point = "/v5/market/tickers"
    method = "GET"
    payload = "category=spot&symbol=BTCUSDT"

    # Отпраляем запрос и получаем ответ от Bybit
    response = client.http_request(end_point, method, payload)

    # Преобразуем JSON ответ в объект Ruby
    @api_response = JSON.parse(response)

    # Выведем для отладки
    Rails.logger.info @api_response
  end
end
