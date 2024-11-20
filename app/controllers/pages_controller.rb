class PagesController < ApplicationController
  def dashboard
    client = BybitApi.new

    end_point = "/v5/account/wallet-balance"
    method = "GET"
    payload = "accountType=UNIFIED&coin=BTC"

    begin
      # Отправляем запрос и получаем ответ от Bybit
      response = client.http_request(end_point, method, payload)

      # Убедимся, что response - строка
      response_body = response.is_a?(Net::HTTPResponse) ? response : response

      # Преобразуем JSON ответ в объект Ruby
      @api_response = JSON.parse(response_body)
    end
  end
end
