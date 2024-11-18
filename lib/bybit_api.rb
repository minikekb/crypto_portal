require "digest"
require "uri"
require "net/http"
require "open-uri"
require "openssl"
require "dotenv/load"
require "json"

class BybitApi
  BASE_URL = "https://api-testnet.bybit.com"
  # Когда создаю новый экземпляр класса срабатывает данный метод
  def initialize
    @api_key = ENV["BYBIT_API_KEY"]
    @secret_key = ENV["BYBIT_SECRET_KEY"]
    @recv_window = 5000
  end
  # Данный метод отправляет запрос на Bybit
  def http_request(end_point, method, payload = "")
    uri = URI(BASE_URL + end_point)
    uri.query = payload unless payload.empty?

    # Создание запроса
    request = create_request(method, uri, payload)

    # Отправка запроса
    https = Net::HTTP.new(uri.host, uri.port)
    # Вкл шифорвание
    https.use_ssl = true

    response = https.request(request)
    response.read_body  # Возвращаем тело ответа
  end

  private

  def create_request(method, uri, payload)
    case method.upcase
    when "POST"
      request = Net::HTTP::Post.new(uri, { "Content-Type" => "application/json" })
      request.body = payload unless payload.empty?
    when "GET"
      request = Net::HTTP::Get.new(uri)
    else
      raise "Unsupported HTTP method: #{method}. Use 'GET' or 'POST'."
    end
    request
  end
end
