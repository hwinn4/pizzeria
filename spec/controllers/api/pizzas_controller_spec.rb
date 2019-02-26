# frozen_string_literal: true

require 'rails_helper'

describe Api::PizzasController do
  describe '#index' do
    context 'when there are no pizzas' do
      it 'returns an empty array' do
        get :index
        expect(response.code).to eq('200')
        expect(JSON.parse(response.body)).to eq([])
      end
    end

    context 'when there are pizzas' do
      let(:margherita_pizza) { FactoryBot.create(:pizza) }
      let(:hawaiian_pizza) { FactoryBot.create(:pizza, name: Pizza.names[:hawaiian], price: Money.new(17_00)) }
      it 'returns a list of all available pizzas' do
        expected_response = [
          {
            'id' => margherita_pizza.id,
            'name' => margherita_pizza.name.titleize,
            'price' => '15.00'
          },
          {
            'id' => hawaiian_pizza.id,
            'name' => hawaiian_pizza.name.titleize,
            'price' => '17.00'
          }
        ]

        get :index
        expect(response.code).to eq('200')
        expect(JSON.parse(response.body)).to eq(expected_response)
      end
    end
  end
end
