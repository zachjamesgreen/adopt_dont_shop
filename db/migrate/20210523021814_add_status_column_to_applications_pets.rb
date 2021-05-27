# frozen_string_literal: true

class AddStatusColumnToApplicationsPets < ActiveRecord::Migration[5.2]
  def change
    add_column :applications_pets, :status, :string
  end
end
