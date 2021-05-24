require 'rails_helper'

RSpec.describe 'Index page' do

  before :each do
    @app1 = Application.create! attributes_for(:application)
    @app2 = Application.create! attributes_for(:application)
    @app3 = Application.create! attributes_for(:application)
    @apps = [@app1, @app2, @app3]
  end

  it 'should show all applications' do
    visit '/applications'
    @apps.each do |app|
      expect(page).to have_content app.name
    end
  end
end