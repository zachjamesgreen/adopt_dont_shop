class AdminController < ApplicationController
  def index; end

  def shelter_index
    @shelters = Shelter.all_rev_alpha
    # @shelters_pending = Application.where(status: :pending).flat_map(&:pets).map(&:shelter).uniq.sort_by(&:name)
    @shelters_pending = Shelter.with_pending_apps
  end

  def shelter_show
    @shelter = Shelter.admin_show_info params[:id]
    s = Shelter.find(params[:id])
    @average_age = s.pets.average(:age)
    @adoptable = s.pets.adoptable.size
    @adopted = get_adopted_pets(s)
    @action_required_pets = s.action_required
  end

  def application_index
    @applications = Application.all
  end

  def application_show
    @application = Application.find params[:id]
  end

  def approve_pet
    app = Application.find params[:id]
    # pet = Pet.find params[:pet_id]
    # or
    pet = app.pets.find(params[:pet_id])
    ap = ApplicationPet.find_by(application_id: app.id, pet_id: pet.id)
    ap.status = true
    ap.save

    if app.pets.all? { |pet| pet.approved?(app) }
      app.status = :accepted
      app.save
      app.pets.update(adoptable: false)
      # pet.remove_pet_from_apps(app)
    end
    redirect_to admin_application_show_path(app)
  end

  def approve_pets
    app = Application.find params[:id]

    app.pets.each do |pet|
      next unless pet.adoptable?

      ap = ApplicationPet.find_by(application_id: app.id, pet_id: pet.id)
      ap.status = true
      ap.save
    end

    if app.pets.all? { |pet| pet.approved?(app) }
      app.status = :accepted
      app.save
      app.pets.update(adoptable: false)
      # app.pets.each do |pet|
      #   pet.remove_pet_from_apps(app)
      # end
    else
      flash[:pet_error] = "One or more pets can't be Approved"
      redirect_to admin_application_show_path(app)
      return
    end

    redirect_to admin_application_show_path(app)
  end

  def reject_pet
    app = Application.find params[:id]
    ap = ApplicationPet.find_by(application_id: app.id, pet_id: params[:pet_id])
    ap.status = false
    ap.save
    app.status = :rejected
    app.save
    redirect_to admin_application_show_path(app)
  end

  private

  # Returns an array of pets that have been adopted for a given shelter
  # A pet is adopted if it is apart of an accepted application
  def get_adopted_pets(shelter)
    shelter.pets.map do |pet|
      pet if pet.applications.any? { |a| a.status == 'accepted' }
    end
  end
end
