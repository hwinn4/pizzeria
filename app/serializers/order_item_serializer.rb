class OrderItemSerializer < ActiveModel::Serializer
  attributes :quantity

  belongs_to :pizza
end