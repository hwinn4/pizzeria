# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order do
  subject { Order.new }

  specify 'associations' do
    should have_many :order_items
  end
end