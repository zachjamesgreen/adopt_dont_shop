class ApplicationsController < ApplicationController
  def index; end

  def new
    @application = Application.new
  end

  def create
    app = Application.create(application_params)
    redirect_to applications_show_path(app)
  end

  def show
    @application = Application.find(params[:id])
  end

  private

  def application_params
    params.require(:application).permit(:name, :street, :city, :state, :zip_code, :desc, :status)
  end
end
