require 'rails_helper'

RSpec.describe 'Admin Features' do

  before(:each) do
    @shelter_1 = Shelter.create! attributes_for(:shelter)
    @shelter_2 = Shelter.create! attributes_for(:shelter)
    @shelter_3 = Shelter.create! attributes_for(:shelter)
    @shelters = [@shelter_1,@shelter_2,@shelter_3]
  end

  it 'should show all shelters in alpha desc' do
    visit '/admin/shelters'
    sorted_shelters = @shelters.sort_by(&:name)
    expect(sorted_shelters[2].name).to appear_before(sorted_shelters[1].name)
    expect(sorted_shelters[1].name).to appear_before(sorted_shelters[0].name)
  end

  xit 'should see section of shelters with pending applications' do
    app1 = Application.create! attributes_for(:application)
    app2 = Application.create! attributes_for(:application)
    pet1 = @shelter_1.pets.create attributes_for(:pet)
    pet2 = @shelter_1.pets.create attributes_for(:pet)
    app1.pets << pet1
    app2.pets << pet2
    app1.status = :pending
    app2.status = :pending
    visit '/admin/shelters'
    expect(page).to have_content "Shelter's with Pending Applications"
    within '#shelters_pending_pets' do
      expect(page).to have_content @shelter_1.name
      expect(page).to have_content @shelter_2.name
    end
  end

  it 'should approve pet on application' do
    app1 = Application.create! attributes_for(:application)
    pet1 = @shelter_1.pets.create attributes_for(:pet)
    app1.pets << pet1
    app1.status = :pending
    visit "/admin/applications/#{app1.id}"
    expect(page).to have_link 'Approve', href: "/admin/applications/#{app1.id}/approve_pet/#{pet1.id}"
    click_on 'Approve'
    expect(page).to have_no_link 'Approve'
    expect(page).to have_content '✅ Approved'
  end
end