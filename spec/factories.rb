# frozen_string_literal: true

FactoryBot.define do
  factory :application do
    name { Faker::Name.name }
    street { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
    zip_code { Faker::Address.zip_code }
  end

  factory :pet do
    adoptable { true }
    # adoptable {rand(2) == 0 ? true : false}
    age { rand(20) }
    breed { Faker::Creature::Dog.breed }
    name { Faker::Creature::Dog.name }
  end

  factory :shelter do
    foster_program { true }
    # foster_program {rand(2) == 0 ? true : false}
    name { Faker::Games::Pokemon.unique.location }
    city { Faker::Address.city }
    rank { rand(11) }
  end
end
