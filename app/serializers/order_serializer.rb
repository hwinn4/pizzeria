# frozen_string_literal: true

class OrderSerializer < ActiveModel::Serializer
  attributes :id, :completed_on, :total_price

  has_many :order_items

  def total_price
    price = object.total_price
    price > 0 ? '%.2f' % object.total_price.amount : 0
  end
end