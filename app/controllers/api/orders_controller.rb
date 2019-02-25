# frozen_string_literal: true

class Api::OrdersController < ApplicationController
  def create
    # Note: I built this endpoint out so that it creates the order and the order
    # items per the instructions
    # However, if this API were consumed by a UI, I might instead choose only to
    # create the Order via this endpoint.
    # Once the order was created and the client had the order id, the client could
    # make parallel requests to the server to create each order item via an
    # OrderItem controller

    order = Order.create
    order_item_params[:order_items].each do |order_item_hash|
      build_order_item(order, order_item_hash)
    end

    if order.save
      render json: order, status: :created
    else
      errors = order_item_errors(order)
      render json: { errors: { order_items: errors } }, status: :bad_request
    end
  end

  def index
    render json: Order.all, each_serializer: OrderSerializer
  end

  def show
    begin
      render json: Order.find(params[:id])
    rescue
      render json: [], status: :not_found
    end
  end

  private

  def build_order_item(order, order_item_hash)
    order.order_items.build(pizza_id: order_item_hash[:pizza_id], quantity: order_item_hash[:quantity])
  end

  def order_item_errors(order)
    order.order_items.map do |order_item|
      order_item.errors.messages unless order_item.valid?
    end.compact
  end

  def order_item_params
    params.require(:order).permit(order_items: [:pizza_id, :quantity])
  end
end