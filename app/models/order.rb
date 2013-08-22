class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :stock

  # def self.total_cost(user_id)

  # 	buy_order = Order.where("user_id =? AND buy_price < 0",user_id)
  #   sell_order = Order.where("user_id =? AND sell_price > 0",user_id)

  # 	totalBuy = buy_order.to_a.sum { |order| order.buy_price * order.quantity }
  # 	totalSell = sell_order.to_a.sum { |order| order.sell_price * order.quantity }

  # 	totalCost = totalBuy + totalSell

  # end

  # def self.sell_item(order_id)
    
  # 	order = Order.find_by(id: order_id)
  # 	order.price = order.price * -1 
  # 	order.save
  # end


  def self.get_total_quantity(user_id, symbol)

    puts 'userID passed in=='+user_id.to_s
    puts 'symbol passed in =='+symbol.to_s 

    #getting all the orders that was placed
    buy_order = Order.joins(:stock).where("user_id =? AND symbol=? AND buy_price > 0",user_id,symbol)
    sell_order = Order.joins(:stock).where("user_id =? AND symbol=? AND sell_price > 0",user_id,symbol)

    puts 'number of buy order ==' + buy_order.length.to_s 
    puts 'numebr of sell order ==' + sell_order.length.to_s 

    total_quantity = 0
    buy_order.each do |buy|
      total_quantity = total_quantity + buy.quantity
    end 

    sell_order.each do |sell|
      total_quantity = total_quantity - sell.quantity
    end

    return total_quantity

    #Order.joins(:stock).where("user_id =1 AND symbol='CC3.SI' AND buy_price > 0")

  end

end
