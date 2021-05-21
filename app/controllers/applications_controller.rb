class ApplicationsController < ApplicationController
  def index; end

  def new
    @application = Application.new
  end

  def create
    @application = Application.new(application_params)
    if @application.save
      redirect_to applications_show_path(@application), notice: "Application saved"
    else
      flash[:error] = @application.errors.full_messages
      render :new
    end
  end

  def show
    @application = Application.find(params[:id])
    @pets = Pet.search(params[:term]) if params[:term]
  end

  private

  def application_params
    params.require(:application).permit(:name, :street, :city, :state, :zip_code, :desc, :status)
  end
end
