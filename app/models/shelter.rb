# frozen_string_literal: true

class Shelter < ApplicationRecord
  validates :name, presence: true
  validates :rank, presence: true, numericality: true
  validates :city, presence: true

  has_many :pets, dependent: :destroy

  def self.order_by_recently_created
    order(created_at: :desc)
  end

  def self.order_by_number_of_pets
    select('shelters.*, count(pets.id) AS pets_count')
      .joins('LEFT OUTER JOIN pets ON pets.shelter_id = shelters.id')
      .group('shelters.id')
      .order('pets_count DESC')
  end

  # Returns all shelters and order by name descending
  def self.all_rev_alpha
    find_by_sql('SELECT * FROM shelters ORDER BY name DESC')
  end

  # Return the name and city of a shelter and grab the first one
  def self.admin_show_info(id)
    find_by_sql("SELECT name, city FROM shelters WHERE id = #{id}")[0]
  end

  # After joining pets and applications tables
  # Return all the shelters
  # that have an associating pending application order by name
  def self.with_pending_apps
    joins(pets: :applications).where({ applications: { status: :pending } }).group(:id).order(:name)
  end

  # Returns pets that do not have a decision made for them on an application
  def action_required
    ids = ApplicationPet.distinct.select(:pet_id).where(pet_id: pets.ids, status: nil).pluck(:pet_id)
    Pet.where(id: ids)
  end

  def pet_count
    pets.count
  end

  def adoptable_pets
    pets.adoptable
  end

  def alphabetical_pets
    adoptable_pets.order(name: :asc)
  end

  def shelter_pets_filtered_by_age(age_filter)
    adoptable_pets.where('age >= ?', age_filter)
  end
end
