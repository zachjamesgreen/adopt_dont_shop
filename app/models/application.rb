# frozen_string_literal: true

class Application < ApplicationRecord
  has_many :application_pets, dependent: :destroy
  has_many :pets, through: :application_pets

  validates :name, presence: true
  validates :street, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip_code, presence: true
  # validates :desc, presence: true

  enum status: { in_progress: 'in_progress', pending: 'pending', accepted: 'accepted', rejected: 'rejected' }

  # Finds all the pets that are not associated with the given application
  def get_pets_not_on_app
    Pet.where.not(id: pets.ids)
  end

  # def all_pets_approved?
  #   ActiveRecord::Base.connection.execute("
  #     SELECT bool_and(ap.status)
  #     FROM   pets as p
  #     JOIN applications_pets as ap ON  p.id = ap.pet_id
  #     JOIN applications as a ON a.id = ap.application_id
  #     WHERE a.id = #{id};").values.flatten[0]
  # end


end
