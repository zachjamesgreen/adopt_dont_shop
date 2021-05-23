class DropApplicationsPets < ActiveRecord::Migration[5.2]
  def change
    drop_table :applications_pets
  end
end
