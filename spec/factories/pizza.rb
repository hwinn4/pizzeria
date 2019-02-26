# frozen_string_literal: true

FactoryBot.define do
  factory :pizza, class: Pizza do
    name { Pizza.names[:margherita] }
    price { Money.new(15_00) }
  end
end