class ApplicationPet < ApplicationRecord
  self.table_name = 'applications_pets'
  validates_uniqueness_of :application_id, scope: :pet_id
  belongs_to :pet
  belongs_to :application
end