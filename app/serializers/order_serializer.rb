class OrderSerializer < ActiveModel::Serializer
  attributes :id, :completed_on

  has_many :order_items
end