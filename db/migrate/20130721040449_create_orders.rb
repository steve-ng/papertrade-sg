class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.decimal :price
      t.integer :quantity, default: 1
      t.references :stock, index: true
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
