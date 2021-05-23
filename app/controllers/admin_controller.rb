class AdminController < ApplicationsController

  def shelter_index
    @shelters = Shelter.all_rev_alpha
    # @shelters_pending
  end

  def application_show
    @application = Application.find params[:id]
  end

  def approve_pet
    app = Application.find params[:id]
    ap = ApplicationPet.where(application_id: app.id, pet_id: params[:pet_id]).first
    ap.status = true
    ap.save
    redirect_to admin_application_show_path(app)
  end

  def reject_pet
    app = Application.find params[:id]
    ApplicationPet.where(application_id: app.id, pet_id: params[:pet_id]).first
    ap.status = false
    ap.save
    redirect_to admin_application_show_path(app)
  end
end