# frozen_string_literal: true

require 'rails_helper'

describe Api::OrdersController do
  describe '#create' do
    let(:margherita_pizza) { FactoryBot.create(:pizza) }
    let(:hawaiian_pizza) { FactoryBot.create(:pizza, name: Pizza.names[:hawaiian], price: Money.new(1700)) }

    context 'when the order is successfully created' do
      let(:params) do
        {
          order: {
            order_items: [
              { pizza_id: margherita_pizza.id, quantity: 1 },
              { pizza_id: hawaiian_pizza.id, quantity: 2 }
            ]
          }
        }
      end
      it 'returns 201' do
        post :create, params: params

        expected_response = {
          id: Order.first.id,
          completed_on: nil,
          order_items: [
            {
              quantity: 1,
              pizza: {
                name: margherita_pizza.name,
                price: '%.2f' % margherita_pizza.price.amount
              }
            },
            {
                quantity: 2,
                pizza: {
                    name: hawaiian_pizza.name,
                    price: '%.2f' % hawaiian_pizza.price.amount
                }
            },

          ]
        }
        expect(response.code).to eq('201')
        expect(response.body).to eq(expected_response.to_json)
      end
    end

    context 'when the order cannot be created successfully' do
      context 'when a quantity is invalid' do
        let(:params) do
          {
            order: {
              order_items: [
                { pizza_id: Pizza.names[:extra_cheese], quantity: 0 },
                { pizza_id: Pizza.names[:hawaiian], quantity: 2 }
              ]
            }
          }
        end
        it 'returns 400' do
          post :create, params: params

          expected_response = { order_items: ["is invalid"] }
          expect(response.code).to eq('400')
          expect(response.body).to eq(expected_response.to_json)
        end
      end

      context 'when a pizza name is invalid' do
        let(:params) do
          {
              order: {
                  order_items: [
                      { pizza_id: 'invalid pizza name', quantity: 0 },
                      { pizza_id: Pizza.names[:hawaiian], quantity: 2 }
                  ]
              }
          }
        end
        it 'returns 400' do
          post :create, params: params

          expected_response = { order_items: ["is invalid"] }
          expect(response.code).to eq('400')
          expect(response.body).to eq(expected_response.to_json)
        end
      end
    end
  end
end
