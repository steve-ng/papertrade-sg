class DropCombineBuySellDateInOrder < ActiveRecord::Migration
  def change
  	remove_column :orders, :sell_date
  	remove_column :orders, :buy_date
  end
end
