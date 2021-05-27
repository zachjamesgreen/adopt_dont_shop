require 'rails_helper'

RSpec.describe 'application creation' do
  it 'sees start application link' do
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
    expect(find('form')).to have_content('Status')
  end

  it 'is able to fill out and submit form' do
    visit '/applications/new'
    fill_in 'Name', with: 'Zach'
    fill_in 'Street', with: 'Zach'
    fill_in 'City', with: 'Zach'
    fill_in 'State', with: 'Zach'
    fill_in 'Zip Code', with: 'Zach'
    click_button 'commit'
    app = Application.last
    expect(page).to have_current_path "/applications/#{app.id}"
    expect(page).to have_content 'Name: Zach'
    expect(page).to have_content 'Street: Zach'
    expect(page).to have_content 'City: Zach'
    expect(page).to have_content 'State: Zach'
    expect(page).to have_content 'Zip Code: Zach'
    expect(page).to have_content 'Status: In progress'
  end

  it 'fails to save form and show a message when all fields are not complete' do
    app = Application.create attributes_for(:application)
    visit '/applications/new'
    fill_in 'Name', with: 'Zach'
    click_button 'commit'
    expect(page).to have_content "Street can't be blank"
    expect(page).to have_content "City can't be blank"
    expect(page).to have_content "State can't be blank"
    expect(page).to have_content "Zip code can't be blank"
    fill_in 'Name', with: ''
    fill_in 'Street', with: 'Zach'
    fill_in 'City', with: 'Zach'
    fill_in 'State', with: 'Zach'
    fill_in 'Zip Code', with: 'Zach'
    click_button 'commit'
    expect(page).to have_content "Name can't be blank"
    expect(Application.last).to eq app
  end

  it 'adds pet to application' do
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

  it 'submits the application' do
    shelter = Shelter.create! attributes_for(:shelter)
    app = Application.create! attributes_for(:application)
    pet = Pet.new attributes_for(:pet)
    pet.shelter = shelter
    pet.save!
    app.pets << pet
    visit "/applications/#{app.id}"
    within('#desc_form') do
      expect(page).to have_content('Why are you good for this/these pet(s)?')
      expect(page).to have_field('desc')
      fill_in('desc', with: 'Test')
      click_on 'commit'
    end
    expect(page).to have_current_path "/applications/#{app.id}"
    expect(page).to have_content pet.name
    expect(page).to have_no_content 'Add a Pet to this Application'
    expect(page).to have_no_selector :css, '#pet_search_form'
    expect(page).to have_content 'Status: Pending'
  end

  it 'does not have submit button if no pets' do
    app = Application.create! attributes_for(:application)
    visit "/applications/#{app.id}"
    expect(page).to have_no_content 'Why are you good for this/these pet(s)?'
    expect(page).to have_no_selector :css, '#desc_form'
  end
end
