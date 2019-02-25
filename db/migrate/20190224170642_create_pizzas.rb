# frozen_string_literal: true

class CreatePizzas < ActiveRecord::Migration[5.2]
  def change
    create_table :pizzas do |t|
      t.integer :name
      t.monetize :price
    end
  end
end
