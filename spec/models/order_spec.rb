# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order do
  subject { FactoryBot.create(:order) }

  specify 'associations' do
    should have_many :order_items
  end

  describe '#total_price' do
    context 'when the order is not empty' do
      context 'when the order is under $50 (not eligible for discount)' do
        let(:pizza_with_cents1) { FactoryBot.create(:pizza, price: Money.new(9_33)) }
        let(:pizza_with_cents2) { FactoryBot.create(:pizza, price: Money.new(7_77)) }

        it 'returns the sum of all related order item prices' do
          order_item1 = FactoryBot.create(:order_item, pizza_id: pizza_with_cents1.id, quantity: 2)
          order_item2 = FactoryBot.create(:order_item, pizza_id: pizza_with_cents2.id, quantity: 4)
          subject.order_items << order_item1
          subject.order_items << order_item2

          expect(subject.total_price).to eq(Money.new(49_74))
        end
      end
    end

    context 'when the order is empty' do
      it 'returns 0' do
        expect(subject.total_price).to eq(Money.new(0))
      end
    end
  end

  describe '#discount' do
    context 'when the order is eligible for a discount (>= $50)' do
      let(:pizza) { FactoryBot.create(:pizza, price: Money.new(10_00)) }

      it 'returns the discount amount' do
        order_item = FactoryBot.create(:order_item, pizza_id: pizza.id, quantity: 6)
        subject.order_items << order_item

        expect(subject.discount).to eq(Money.new(3_00))
      end
    end

    context 'when the order is not for a discount (<$50)' do
      let(:pizza) { FactoryBot.create(:pizza, price: Money.new(10_00)) }

      it 'returns the discount amount' do
        order_item = FactoryBot.create(:order_item, pizza_id: pizza.id, quantity: 1)
        subject.order_items << order_item

        expect(subject.discount).to eq(Money.new(0))
      end
    end
  end

  describe '#grand_total' do
    context 'when there is a discount' do
      let(:pizza) { FactoryBot.create(:pizza, price: Money.new(10_00)) }

      it 'returns the total_price minus the discount' do
        order_item = FactoryBot.create(:order_item, pizza_id: pizza.id, quantity: 6)
        subject.order_items << order_item

        expect(subject.grand_total).to eq(Money.new(57_00))
      end
    end

    context 'when there is not a discount' do
      let(:pizza) { FactoryBot.create(:pizza, price: Money.new(10_00)) }

      it 'returns the total_price' do
        order_item = FactoryBot.create(:order_item, pizza_id: pizza.id, quantity: 1)
        subject.order_items << order_item

        expect(subject.grand_total).to eq(Money.new(10_00))
      end
    end
  end
end