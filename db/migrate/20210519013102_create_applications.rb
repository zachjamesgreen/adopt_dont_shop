class CreateApplications < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      CREATE TYPE application_status AS ENUM ('in_progress', 'pending', 'accepted', 'rejected');
    SQL
    create_table :applications do |t|
      t.string :name
      t.string :street
      t.string :city
      t.string :state
      t.string :zip_code
      t.text :desc
    end

    add_column :applications, :status, :application_status

  end

  def down
    remove_column :applications, :status, :application_status
    drop_table :applications
    execute <<-SQL
      DROP TYPE application_status;
    SQL
  end
end