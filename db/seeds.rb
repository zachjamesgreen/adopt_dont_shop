# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# FactoryBot.define do
#   factory :application do
#     name {Faker::Name.name }
#     street {Faker::Address.street_address}
#     city {Faker::Address.city}
#     state {Faker::Address.state_abbr}
#     zip_code {Faker::Address.zip_code}
#     desc {Faker::Lorem.paragraph}
#     status {%w(in_progress pending accepted rejected).sample}
#   end
#
#   factory :pet do
#     adoptable { true }
#     # adoptable {rand(2) == 0 ? true : false}
#     age {rand(20) }
#     breed {Faker::Creature::Dog.breed}
#     name {Faker::Creature::Dog.name}
#   end
#
#   factory :shelter do
#     foster_program { true }
#     # foster_program {rand(2) == 0 ? true : false}
#     name {Faker::Games::Pokemon.location}
#     city {Faker::Address.city}
#     rank {rand(11)}
#   end
# end
require 'factory_bot'

10.times do |i|
  s = ::Shelter.create!(FactoryBot::attributes_for(:shelter))
  5.times do |j|
    s.pets.create!(FactoryBot::attributes_for(:pet))
  end
end