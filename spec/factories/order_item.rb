# frozen_string_literal: true

FactoryBot.define do
  factory :order_item, class: OrderItem do
    quantity { 1 }
    pizza
    order
  end
end