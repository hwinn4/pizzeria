# frozen_string_literal: true

class OrderSerializer < ActiveModel::Serializer
  attributes :id,
             :completed_on,
             :total_price,
             :grand_total,
             :discount

  has_many :order_items

  def total_price
    price = object.total_price
    price > 0 ? '%.2f' % price.amount : 0
  end

  def discount
    discount = object.discount
    discount > 0 ? '%.2f' % discount.amount : 0
  end

  def grand_total
    price = object.grand_total
    price > 0 ? '%.2f' % price.amount : 0
  end
end