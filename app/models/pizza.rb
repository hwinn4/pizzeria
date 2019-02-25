# frozen_string_literal: true

class Pizza < ApplicationRecord
  validates_presence_of :name
  validates :price_cents, numericality: { greater_than: 0 }

  enum name: %i[
          margherita
          pepperoni
          bbq_chicken
          hawaiian
          meat_lover
          veggie_supreme
          extra_cheese
        ]

  monetize :price_cents
end