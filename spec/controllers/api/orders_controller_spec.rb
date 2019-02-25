# frozen_string_literal: true

require 'rails_helper'

describe Api::OrdersController do
  let(:margherita_pizza) { FactoryBot.create(:pizza) }
  let(:hawaiian_pizza) do
    FactoryBot.create(:pizza, name: Pizza.names[:hawaiian], price: Money.new(1700))
  end

  let(:valid_params) do
    {
      'order' => {
        'order_items' => [
          { 'pizza_id' => margherita_pizza.id, 'quantity' => 1 },
          { 'pizza_id' => hawaiian_pizza.id, 'quantity' => 2 }
        ]
      }
    }
  end

  let(:valid_response) do
    {
      'completed_on' => nil,
      'total_price' => '49.00',
      'order_items' => [
        {
          'quantity' => 1,
          'pizza' => {
            'id' => margherita_pizza.id,
            'name' => margherita_pizza.name.titleize,
            'price' => format('%.2f', margherita_pizza.price.amount)
          }
        },
        {
          'quantity' => 2,
          'pizza' => {
            'id' => hawaiian_pizza.id,
            'name' => hawaiian_pizza.name.titleize,
            'price' => format('%.2f', hawaiian_pizza.price.amount)
          }
        }
      ]
    }
  end

  describe '#create' do
    context 'when the order is successfully created' do
      it 'returns 201' do
        post :create, params: valid_params

        expected_valid_response = { 'id' => Order.first.id }.merge!(valid_response)
        expect(response.code).to eq('201')
        expect(JSON.parse(response.body)).to eq(expected_valid_response)
      end
    end

    context 'when the order cannot be created successfully' do
      context 'when a quantity is invalid' do
        let(:invalid_params) do
          {
            'order' => {
              'order_items' => [
                { 'pizza_id' => margherita_pizza.id, 'quantity' => 0 },
                { 'pizza_id' => hawaiian_pizza.id, 'quantity' => 2 }
              ]
            }
          }
        end
        it 'returns 400' do
          post :create, params: invalid_params

          expected_response = { errors: { order_items: [{quantity: ['must be greater than 0'] }] } }
          expect(response.code).to eq('400')
          expect(response.body).to eq(expected_response.to_json)
        end
      end

      context 'when a pizza name is invalid' do
        let(:params) do
          {
            'order' => {
              'order_items' => [
                { 'pizza_id' => 0, 'quantity' => 1 },
                { 'pizza_id' => margherita_pizza.id, 'quantity' => 2 }
              ]
            }
          }
        end
        it 'returns 400' do
          post :create, params: params

          expected_response = { errors: { order_items: [{ pizza: ['must exist'] }] } }
          expect(response.code).to eq('400')
          expect(response.body).to eq(expected_response.to_json)
        end
      end
    end
  end

  describe '#index' do
    context 'when there are no orders in the database' do
      it 'returns an empty array' do
        get :index
        expect(response.code).to eq('200')
        expect(JSON.parse(response.body)).to eq([])
      end
    end

    context 'when there are orders in the database' do
      it 'returns a list of orders including each order total price' do
        post :create, params: valid_params
        post :create, params: valid_params

        order1 = { 'id' => Order.all.first.id }.merge!(valid_response)
        order2 = { 'id' => Order.all.last.id }.merge!(valid_response)
        expected_valid_response = [order1, order2]

        get :index
        expect(response.code).to eq('200')
        expect(JSON.parse(response.body)).to eq(expected_valid_response)
      end
    end
  end

  describe '#show' do
    context 'when the requested resource exists' do
      it 'returns 200 and the requested data' do
        post :create, params: valid_params
        get :show, params: { id: JSON.parse(response.body)['id'] }

        expected_valid_response = { 'id' => Order.first.id }.merge!(valid_response)
        expect(JSON.parse(response.body)).to eq(expected_valid_response)
      end
    end

    context 'when the requested resource is missing' do
      it 'returns 404' do
        get :show, params: { id: 1 }
        expect(response.status).to eq(404)
      end
    end
  end
end
