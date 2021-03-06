# frozen_string_literal: true

class ApplicationsController < ApplicationController
  def index
    @applications = Application.all
  end

  def new
    @application = Application.new
  end

  def create
    @application = Application.new(application_params)
    if @application.save
      redirect_to applications_show_path(@application), notice: 'Application saved'
    else
      flash.now[:application_error] = @application.errors.full_messages
      render :new
    end
  end

  def show
    @application = Application.find(params[:id])
    @pets = @application.pets
    @found_pets = @application.get_pets_not_on_app.search(params[:term]) if params[:term]
  end

  def update
    app = Application.find params[:id]

    if params[:pet_id]
      app.pets << Pet.find(params[:pet_id])
      redirect_to applications_show_path(app)
      return
    end

    if params[:desc]
      app.desc = params[:desc]
      app.status = :pending
      app.save!
      redirect_to applications_show_path(app)
    end
  end

  private

  def application_params
    params.require(:application).permit(:name, :street, :city, :state, :zip_code, :desc)
  end
end
