require 'factory_bot'

ApplicationPet.delete_all
Application.delete_all
Pet.delete_all
Shelter.delete_all

10.times do |i|
  s = ::Shelter.create!(FactoryBot::attributes_for(:shelter))
  5.times do |j|
    s.pets.create!(FactoryBot::attributes_for(:pet))
  end
end

5.times do
  Application.create! FactoryBot::attributes_for(:application)
end

