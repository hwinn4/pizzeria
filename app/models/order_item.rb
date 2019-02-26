# frozen_string_literal: true

class OrderItem < ApplicationRecord
  belongs_to :pizza
  belongs_to :order

  validates_presence_of :order_id
  validates_presence_of :pizza_id
  validates :quantity, numericality: { greater_than: 0,  :only_integer => true }

  def price
    pizza.price * quantity
  end
end