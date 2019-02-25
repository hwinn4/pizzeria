# frozen_string_literal: true

require 'rails_helper'

describe Api::OrdersController do
  let(:margherita_pizza) { FactoryBot.create(:pizza) }
  let(:hawaiian_pizza) { FactoryBot.create(:pizza, name: Pizza.names[:hawaiian], price: Money.new(1700)) }

  describe '#create' do
    context 'when the order is successfully created' do
      let(:params) do
        {
          "order" => {
            "order_items" => [
              { "pizza_id" => margherita_pizza.id, "quantity" => 1 },
              { "pizza_id" => hawaiian_pizza.id, "quantity" => 2 }
            ]
          }
        }
      end
      it 'returns 201' do
        post :create, params: params

        expected_response = {
          "id" => Order.first.id,
          "completed_on" => nil,
          "total_price" => "49.00",
          "order_items" => [
            {
              "quantity" => 1,
              "pizza" => {
                "id" => margherita_pizza.id,
                "name" => margherita_pizza.name.titleize,
                "price" => "%.2f" % margherita_pizza.price.amount
              }
            },
            {
                "quantity" => 2,
                "pizza" => {
                    "id" => hawaiian_pizza.id,
                    "name" => hawaiian_pizza.name.titleize,
                    "price" => '%.2f' % hawaiian_pizza.price.amount
                }
            },

          ]
        }
        expect(response.code).to eq('201')
        expect(JSON.parse(response.body)).to eq(expected_response)
      end
    end

    context 'when the order cannot be created successfully' do
      context 'when a quantity is invalid' do
        let(:params) do
          {
            "order" => {
              "order_items" => [
                { "pizza_id" => Pizza.names[:extra_cheese], "quantity" => 0 },
                { "pizza_id" => Pizza.names[:hawaiian], "quantity" => 2 }
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
              "order" => {
                  "order_items" => [
                      { "pizza_id" => "invalid pizza id", "quantity" => 0 },
                      { "pizza_id" => Pizza.names[:hawaiian], "quantity" => 2 }
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

  describe '#index' do
    context 'when there are no orders in the database' do
      it 'returns an empty array' do
        get :index
        expect(response.code).to eq('200')
        expect(JSON.parse(response.body)).to eq([])
      end
    end

    context 'when there are orders in the database' do
      # TODO: Review why use Factory Bot
      it 'returns a list of orders including each order total price' do
        # TODO: Why didn't let work outside of the example?
        order = FactoryBot.create(:order)
        FactoryBot.create(:order_item, pizza: margherita_pizza, order: order)
        FactoryBot.create(:order_item, pizza: hawaiian_pizza, order: order, quantity: 2)

        order2 = FactoryBot.create(:order)
        FactoryBot.create(:order_item, pizza: margherita_pizza, order: order2, quantity: 2)
        FactoryBot.create(:order_item, pizza: hawaiian_pizza, order: order2, quantity: 2)

        expected_response = [{
            "id" => order.id,
            "completed_on" => nil,
            "total_price" => "49.00",
            "order_items" => [
                {
                    "quantity" => 1,
                    "pizza" => {
                        "id" => margherita_pizza.id,
                        "name" => margherita_pizza.name.titleize,
                        "price" => "%.2f" % margherita_pizza.price.amount
                    }
                },
                {
                    "quantity" => 2,
                    "pizza" => {
                        "id" => hawaiian_pizza.id,
                        "name" => hawaiian_pizza.name.titleize,
                        "price" => "%.2f" % hawaiian_pizza.price.amount
                    }
                },

            ]
        }, {
            "id" => order2.id,
            "completed_on" => nil,
            "total_price" => "64.00",
            "order_items" => [
                {
                    "quantity" => 2,
                    "pizza" => {
                        "id" => margherita_pizza.id,
                        "name" => margherita_pizza.name.titleize,
                        "price" => "%.2f" % margherita_pizza.price.amount
                    }
                },
                {
                    "quantity" => 2,
                    "pizza" => {
                        "id" => hawaiian_pizza.id,
                        "name" => hawaiian_pizza.name.titleize,
                        "price" => '%.2f' % hawaiian_pizza.price.amount
                    }
                },

            ]
        }]

        get :index
        # TODO: Run Rubocop
        expect(response.code).to eq('200')
        expect(JSON.parse(response.body)).to eq(expected_response)
      end
    end
  end
end
