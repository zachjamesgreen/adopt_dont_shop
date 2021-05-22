class Pet < ApplicationRecord
  belongs_to :shelter
  has_many :application_pets, dependent: :destroy
  has_many :applications, through: :application_pets

  validates :name, presence: true
  validates :age, presence: true, numericality: true

  def shelter_name
    shelter.name
  end

  def self.adoptable
    where(adoptable: true)
  end
end
