# frozen_string_literal: true

class OrderItemSerializer < ActiveModel::Serializer
  attributes :quantity

  belongs_to :pizza
end