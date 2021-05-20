class CreateApplications < ActiveRecord::Migration[5.2]

  def up
    create_enum :application_status, %w(in_progress pending accepted rejected)
    create_table :applications do |t|
      t.string :name
      t.string :street
      t.string :city
      t.string :state
      t.string :zip_code
      t.text :desc
      t.references :pet, foreign_key: true
      t.enum :status, enum_name: :application_status, default: 'in_progress', null: false

      t.timestamps
    end
  end

  def down
    drop_table :applications
    drop_enum :application_status
  end
end