class ApplicationPet < ApplicationRecord
  self.table_name = 'applications_pets'
  validates :application_id, uniqueness: { scope: :pet_id }
  belongs_to :pet
  belongs_to :application
end
