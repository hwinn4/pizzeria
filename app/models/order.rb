# frozen_string_literal: true

class Order < ApplicationRecord
  has_many :order_items

  def total_price
    order_items.reduce(0) { |sum, item| sum + item.price }
  end

  def discount
    total = total_price
    return 0 if total < Money.new(50_00)

    discounted_total(total)
  end

  def grand_total
    total_price - discount
  end

  private

  def discounted_total(total)
    total * 0.05
  end
end