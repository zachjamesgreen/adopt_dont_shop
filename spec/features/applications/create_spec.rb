require 'rails_helper'

RSpec.describe 'application creation' do
  it 'should see start application link' do
    visit '/pets'
    expect(page).to have_link 'Start an Application', href: '/applications/new'
  end

  it 'renders the new form' do
    visit '/applications/new'

    expect(page).to have_content('New Application')
    expect(find('form')).to have_content('Name')
    expect(find('form')).to have_content('Street')
    expect(find('form')).to have_content('City')
    expect(find('form')).to have_content('State')
    expect(find('form')).to have_content('Zip Code')
    expect(find('form')).to have_content('Why is your home good for this pet?')
    expect(find('form')).to have_content('Status')
  end

  it 'should be able to fill out and submit form' do
    visit '/applications/new'
    fill_in 'Name', with: 'Zach'
    fill_in 'Street', with: 'Zach'
    fill_in 'City', with: 'Zach'
    fill_in 'State', with: 'Zach'
    fill_in 'Zip Code', with: 'Zach'
    fill_in 'Why is your home good for this pet?', with: 'Zach'
    select('In progress', from: 'application[status]')
    click_button 'commit'
    app = Application.last
    expect(page).to have_current_path "/applications/#{app.id}"
    expect(page).to have_content "Name: Zach"
    expect(page).to have_content "Street: Zach"
    expect(page).to have_content "City: Zach"
    expect(page).to have_content "State: Zach"
    expect(page).to have_content "Zip Code: Zach"
    expect(page).to have_content "Reason: Zach"
    expect(page).to have_content "Status: In progress"
  end

  it 'should fail to save form and show a message when all fields are not complete' do
    app = Application.create attributes_for(:application)
    visit '/applications/new'
    fill_in 'Name', with: 'Zach'
    click_button 'commit'
    expect(page).to have_content "Street can't be blank"
    expect(page).to have_content "City can't be blank"
    expect(page).to have_content "State can't be blank"
    expect(page).to have_content "Zip code can't be blank"
    expect(page).to have_content "Desc can't be blank"
    fill_in 'Name', with: ''
    fill_in 'Street', with: 'Zach'
    fill_in 'City', with: 'Zach'
    fill_in 'State', with: 'Zach'
    fill_in 'Zip Code', with: 'Zach'
    fill_in 'Why is your home good for this pet?', with: 'Zach'
    click_button 'commit'
    expect(page).to have_content "Name can't be blank"
    expect(Application.last).to eq app
  end

  it 'should add pet to application' do
    shelter = Shelter.create! attributes_for(:shelter)
    pet = Pet.new attributes_for(:pet)
    pet.shelter = shelter
    pet.save!
    app = Application.create! attributes_for(:application)
    visit "/applications/#{app.id}"
    fill_in 'term', with: pet.name
    click_button 'commit'

    expect(page).to have_content pet.name

    expect(page).to have_link 'Adopt this Pet', href: "/applications/#{app.id}/#{pet.id}"
    click_link 'Adopt this Pet'
    expect(page).to have_current_path "/applications/#{app.id}"
    expect(page).to have_content pet.name

  end
end