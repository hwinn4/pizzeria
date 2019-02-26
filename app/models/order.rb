# frozen_string_literal: true

class Order < ApplicationRecord
  has_many :order_items

  def total_price
    order_items.reduce(0) { |sum, item| sum + item.price }
  end
end