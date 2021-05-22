class Application < ApplicationRecord
  has_many :application_pets, dependent: :destroy
  has_many :pets, through: :application_pets

  validates :name, presence: true
  validates :street, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip_code, presence: true
  # validates :desc, presence: true

  enum status: {in_progress: 'in_progress', pending: 'pending', accepted: 'accepted', rejected: 'rejected'}

  def get_pets_not_on_app
    Pet.where.not(id: self.pets.ids)
  end
end
