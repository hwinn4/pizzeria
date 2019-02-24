class CreateOrderItem < ActiveRecord::Migration[5.2]
  def change
    create_table :order_items do |t|
      t.belongs_to :pizza
      t.belongs_to :order
      t.integer :quantity
    end
  end
end
