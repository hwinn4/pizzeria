# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pizza do
  subject { Pizza.new(name: Pizza.names[:margherita], price_cents: 1500) }

  describe 'validations' do
    it { should validate_numericality_of(:price_cents) }
    it { should_not allow_value(nil).for(:name) }
    it { should_not allow_value(nil).for(:price_cents) }
    it { should_not allow_value(0).for(:price_cents) }
    it { should_not allow_value(-1.0).for(:price_cents) }
    it { should allow_value(0.01).for(:price_cents) }
    it {
      should define_enum_for(:name)
        .with(
          %i[margherita
             pepperoni
             bbq_chicken
             hawaiian
             meat_lover
             veggie_supreme
             extra_cheese]
        )
    }
  end
end
