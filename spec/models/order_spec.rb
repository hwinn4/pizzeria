# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order do
  subject { FactoryBot.create(:order) }

  specify 'associations' do
    should have_many :order_items
  end

  describe '#total_price' do
    context 'when the order is not empty' do
      let(:pizza_with_cents1) { FactoryBot.create(:pizza, price: Money.new(17_33)) }
      let(:pizza_with_cents2) { FactoryBot.create(:pizza, price: Money.new(11_21)) }

      it 'returns the sum of all related order item prices' do
        order_item1 = FactoryBot.create(:order_item, pizza_id: pizza_with_cents1.id, quantity: 2)
        order_item2 = FactoryBot.create(:order_item, pizza_id: pizza_with_cents2.id, quantity: 5)
        subject.order_items << order_item1
        subject.order_items << order_item2

        expect(subject.total_price).to eq(Money.new(90_71))
      end
    end

    context 'when the order is empty' do
      it 'returns 0' do
        expect(subject.total_price).to eq(Money.new(0))
      end
    end
  end
end