# frozen_string_literal: true

class Order < ApplicationRecord
  has_many :order_items

  def total_price
    # TODO: https://www.brianstorti.com/understanding-ruby-idiom-map-with-symbol/
    order_items.map(&:price).sum
  end
end