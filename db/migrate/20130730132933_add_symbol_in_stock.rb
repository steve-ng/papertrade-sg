class AddSymbolInStock < ActiveRecord::Migration
  def change
  	add_column :stocks, :symbol, :string
  end
end
