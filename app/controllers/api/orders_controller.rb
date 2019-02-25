# frozen_string_literal: true

class Api::OrdersController < ApplicationController
  def create
    order = Order.create
    order_item_params[:order_items].each do |order_item_hash|
      order.order_items.build(pizza_id: order_item_hash[:pizza_id], quantity: order_item_hash[:quantity])
    end
    # TODO: Is there a better way to do this so that the errors are clearer?
    if order.save
      render json: order, status: :created
    else
      render json: order.errors, status: :bad_request
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

  def order_item_params
    params.require(:order).permit(order_items: [:pizza_id, :quantity])
  end
end