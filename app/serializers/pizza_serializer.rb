class PizzaSerializer < ActiveModel::Serializer
  attributes :name, :price

  def price
    '%.2f' % object.price.amount
  end
end