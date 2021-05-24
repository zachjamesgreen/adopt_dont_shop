class AdminController < ApplicationsController

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
    ids = ApplicationPet.distinct.select(:pet_id).where(pet_id: s.pets.ids, status: nil).pluck(:pet_id)
    @action_required_pets = Pet.where(id: ids)
  end

  def application_index
    @applications = Application.all
  end

  def application_show
    @application = Application.find params[:id]
  end

  def approve_pet
    app = Application.find params[:id]
    ap = ApplicationPet.find_by(application_id: app.id, pet_id: params[:pet_id])
    ap.status = true
    ap.save
    if app.pets.all? { |pet| pet.approved?(app) }
      app.status = :accepted
      app.save
      app.pets.update(adoptable: false)
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

  def get_adopted_pets(shelter)
    adopted = []
    shelter.pets.each do |pet|
      if pet.applications.any?{ |a| a.status == 'accepted'}
        adopted << pet
      end
    end
    adopted
  end
end