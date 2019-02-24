require 'rails_helper'

RSpec.describe Pizza do
  subject { Pizza.new(name: 'Margherita', price_cents: 1500) }

  describe 'validations' do
    it { should validate_numericality_of(:price_cents) }
    it { should_not allow_value(nil).for(:name) }
    it { should_not allow_value(0).for(:price_cents) }
    it { should_not allow_value(-1.0).for(:price_cents) }
    it { should allow_value(1500).for(:price_cents) }
  end
end