# frozen_string_literal: true

class CreateNewApplicationsPets < ActiveRecord::Migration[5.2]
  def change
    create_table :applications_pets do |t|
      t.references :application, index: true, foreign_key: true
      t.references :pet, index: true, foreign_key: true
      t.boolean :status
    end
  end
end
