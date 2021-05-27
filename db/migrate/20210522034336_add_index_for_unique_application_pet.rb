class AddIndexForUniqueApplicationPet < ActiveRecord::Migration[5.2]
  def change
    add_index :applications_pets, %i[application_id pet_id], unique: true, name: 'by_application_and_pet'
  end
end
