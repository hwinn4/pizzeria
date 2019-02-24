class Api::OrdersController < ApplicationController
  def create
    order = Order.create

    order_item_params[:order_items].each do |order_item_params|
      order.order_items.build(pizza_id: order_item_params[:pizza_id], quantity: order_item_params[:quantity])
    end

    if order.save
      render json: order, status: :created
    else
      render json: order.errors, status: :bad_request
    end
  end

  private

  def order_item_params
    params.require(:order).permit(order_items: [:pizza_id, :quantity])
  end
end