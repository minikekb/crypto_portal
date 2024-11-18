class ApiController < ApplicationController
  def show
    client = BybitAPI.new

    end_point = "v5/market/tickers"
    method = "GET"
    payload = "symbol=BTCUSD"

    @response = client.http_request(end_point, method, payload)
  end
end
