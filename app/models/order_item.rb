class OrderItem < ApplicationRecord
  belongs_to :pizza
  belongs_to :order

  validates_presence_of :order_id # TODO: Should I do this or require it at the db level?
  validates_presence_of :pizza_id
  validates_presence_of :quantity
end