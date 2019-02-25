# frozen_string_literal: true

class Api::PizzasController < ApplicationController
  def index
    render json: Pizza.all, each_serializer: PizzaSerializer
  end
end