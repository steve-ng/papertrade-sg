json.array!(@stocks) do |stock|
  json.extract! stock, :\, :counter_name, :price
  json.url stock_url(stock, format: :json)
end
