FactoryBot.define do
  factory :pizza, class: Pizza do
    name { Pizza.names[:margherita] }
    price { Money.new(1500) }
  end
end