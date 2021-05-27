require 'factory_bot'

ActiveRecord::Base.transaction do
  ApplicationPet.delete_all
  Application.delete_all
  Pet.delete_all
  Shelter.delete_all
end

ActiveRecord::Base.transaction do
  10.times do
    s = ::Shelter.create!(FactoryBot.attributes_for(:shelter))
    5.times do
      s.pets.create!(FactoryBot.attributes_for(:pet))
    end
  end

  5.times do
    Application.create! FactoryBot.attributes_for(:application)
  end
end
