class ChangeBuyToNegativePriceInOrder < ActiveRecord::Migration
  def up
  	Order.all.each do |order|
  		order.price = order.price * -1
  		order.save
  	end
  end

  def down
  end 
end
