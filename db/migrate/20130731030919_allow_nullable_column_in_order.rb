class AllowNullableColumnInOrder < ActiveRecord::Migration
  def change
  	change_column :orders, :buy_price, :decimal, :null => true
  	change_column :orders, :sell_price, :decimal, :null => true
  	change_column :orders, :buy_date, :datetime, :null => true
  	change_column :orders, :sell_date, :datetime, :null => true
  end
end
