class AddBuySellPriceDateToOrder < ActiveRecord::Migration
  def change
  	add_column :orders, :buy_price, :decimal
  	add_column :orders, :sell_price, :decimal
  	add_column :orders, :buy_date, :datetime
  	add_column :orders, :sell_date, :detetime
  end
end
