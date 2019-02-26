# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrderItem do
  let(:quantity) { 1 }
  subject { OrderItem.new(pizza_id: 1, quantity: quantity) }

  describe 'validations' do
    it { should_not allow_value(nil).for(:order_id) }
    it { should_not allow_value(nil).for(:pizza_id) }
    it { should_not allow_value(nil).for(:quantity) }
    it { should_not allow_value(0).for(:quantity) }
    it { should_not allow_value(-1).for(:quantity) }
    it { should_not allow_value(1.5).for(:quantity) }
    it { should allow_value(1).for(:quantity) }
  end

  specify 'associations' do
    should belong_to :order
    should belong_to :pizza
  end

  describe '#price' do
    context 'example 1' do
      let(:quantity) { 7 }
      let(:pizza) { mock_model(Pizza, name: Pizza.names[:margherita], price: Money.new(15_87)) }

      it 'returns the price times quantity' do
        allow(subject).to receive(:pizza).and_return(pizza)
        expect(subject.price).to eq(Money.new(111_09))
      end
    end

    context 'example 2' do
      let(:quantity) { 2 }
      let(:pizza) { mock_model(Pizza, name: Pizza.names[:margherita], price: Money.new(10_01)) }

      it 'returns the price times quantity' do
        allow(subject).to receive(:pizza).and_return(pizza)
        expect(subject.price).to eq(Money.new(20_02))
      end
    end
  end
end