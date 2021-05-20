class ApplicationsController < ApplicationController
  def index

  end

  def new
    @application = Application.new
  end

  def create
    app = Application.new(application_params)
    app.status = params[:application][:status]
    app.save!
    redirect_to applications_show_path(app)
  end

  def show
    @application = Application.find(params[:id])
  end

  private

  def application_params
    params.require(:application).permit(:name, :street, :city, :state, :zip_code, :desc)
  end
end
