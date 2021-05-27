class Pet < ApplicationRecord
  belongs_to :shelter
  has_many :application_pets, dependent: :destroy
  has_many :applications, through: :application_pets

  validates :name, presence: true
  validates :age, presence: true, numericality: true

  delegate :name, to: :shelter, prefix: true

  # def shelter_name
  #   shelter.name
  # end

  def self.adoptable
    where(adoptable: true)
  end

  # Return the status (true,nil,false) of the pet
  # that is associated with the application `app`
  def approved?(app)
    ApplicationPet.find_by(application_id: app.id, pet_id: id).status
  end

  # Sees if the pet is associated with an application that is accepted
  # Return a boolean
  def accepted?
    if (app = applications.find_by(status: :accepted))
      app.accepted?
    end
  end
end
