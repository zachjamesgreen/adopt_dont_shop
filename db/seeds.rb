require 'factory_bot'

10.times do |i|
  s = ::Shelter.create!(FactoryBot::attributes_for(:shelter))
  5.times do |j|
    s.pets.create!(FactoryBot::attributes_for(:pet))
  end
end