class OrderSerializer < ActiveModel::Serializer
  attributes :id, :completed_on, :total_price

  has_many :order_items

  def total_price
    '%.2f' % object.total_price.amount
  end
end