class ApplicationPet < ApplicationRecord
  self.table_name = 'applications_pets'
  belongs_to :pet
  belongs_to :application
end