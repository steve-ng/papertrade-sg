class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.string :counter_name
      t.decimal :price

      t.timestamps
    end
  end
end
