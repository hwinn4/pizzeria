# frozen_string_literal: true

FactoryBot.define do
  factory :order, class: Order do
    completed_on { nil }
  end
end