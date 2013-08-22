json.array!(@orders) do |order|
  json.extract! order, :price, :quantity, :stock, :user_id
  json.url order_url(order, format: :json)
end
