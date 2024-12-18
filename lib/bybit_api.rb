require "net/http"
require "uri"
require "openssl"
require "time"

class BybitApi
  BASE_URL = "https://api-testnet.bybit.com"

  def initialize(api_key, secret_key)
    @api_key = api_key
    @secret_key = secret_key
    @recv_window = 5000
  end

  def fetch_tickers(symbol, category = "inverse")
    end_point = "/v5/market/tickers"
    method = "GET"
    payload = "category=#{category}&symbol=#{symbol}"

    response = http_request(end_point, method, payload)
    JSON.parse(response.body) # Парсим тело ответа
  end

  def wallet_balance
    end_point = "/v5/account/wallet-balance"
    method = "GET"
    payload = "accountType=UNIFIED&coin=BTC"

    response = http_request(end_point, method, payload)
    JSON.parse(response.body) # Парсим тело ответа
  end

  def create_order(symbol, side, order_type, qty)
    end_point = "/v5/order/create"
    method = "POST"
    payload = {
      category: "spot",
      symbol: symbol,
      side: side,
      orderType: order_type,
      qty: qty,
      marketUnit: "baseCoin"
    }.to_json

    response = http_request(end_point, method, payload)
    JSON.parse(response.body) # Парсим тело ответа
  end

  # Метод для отправки запросов к API Bybit
  def http_request(end_point, method, payload)
    @time_stamp = current_timestamp.to_s # Текущая временная метка
    signature = gen_signature(payload) # Генерация подписи

    # Создание полного URL
    full_url = URI.parse("#{BASE_URL}#{end_point}")

    # Выбор типа запроса
    request = case method
    when "POST"
      req = Net::HTTP::Post.new(full_url, "Content-Type" => "application/json")
      req.body = payload
      req
    when "GET"
      query_string = "?#{payload}"
      full_url = URI.parse("#{BASE_URL}#{end_point}#{query_string}")
      Net::HTTP::Get.new(full_url)
    else
     raise "Unsupported HTTP method: #{method}"
    end

    # Добавление заголовков
    request["X-BAPI-API-KEY"] = @api_key
    request["X-BAPI-TIMESTAMP"] = @time_stamp
    request["X-BAPI-RECV-WINDOW"] = @recv_window.to_s
    request["X-BAPI-SIGN"] = signature

    # Настройка HTTPS-соединения
    https = Net::HTTP.new(full_url.host, full_url.port)
    https.use_ssl = true
    https.verify_mode = OpenSSL::SSL::VERIFY_PEER

    # Отправка запроса и получение ответа
    response = https.request(request)
    response # Возвращаем тело ответа
  end

  # Метод для получения текущего времени в миллисекундах
  def current_timestamp
    (Time.now.to_f * 1000).to_i
  end

  # Метод для генерации подписи
  def gen_signature(payload)
    param_str = "#{@time_stamp}#{@api_key}#{@recv_window}#{payload}"
    OpenSSL::HMAC.hexdigest("sha256", @secret_key, param_str)
  end
end
