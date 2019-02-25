class PizzaSerializer < ActiveModel::Serializer
  attributes :id, :name, :price

  def name
    object.name.titleize
  end

  def price
    '%.2f' % object.price.amount
  end
end