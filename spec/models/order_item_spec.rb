require 'rails_helper'

RSpec.describe OrderItem do
  let(:pizza) { mock_model(Pizza, name: 1, price: Money.new(15_00)) }
  subject { OrderItem.new(pizza_id: pizza.id, quantity: 1) }

  describe 'validations' do
    it { should_not allow_value(nil).for(:order_id) }
    it { should_not allow_value(nil).for(:pizza_id) }
    it { should_not allow_value(nil).for(:quantity) }
  end

  specify 'associations' do
    should belong_to :order
    should belong_to :pizza
  end
end