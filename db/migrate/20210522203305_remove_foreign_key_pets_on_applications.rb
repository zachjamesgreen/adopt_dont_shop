class RemoveForeignKeyPetsOnApplications < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :applications, :pets
    remove_column :applications, :pet_id
  end
end
