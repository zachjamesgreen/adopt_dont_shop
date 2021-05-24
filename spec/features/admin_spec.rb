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

  it 'should see section of shelters with pending applications' do
    app = Application.create! attributes_for(:application)
    pet = @shelter_1.pets.create attributes_for(:pet)
    app.pets << pet
    app.status = :pending
    app.save!
    visit '/admin/shelters'
    expect(page).to have_content "Shelters with pending applications"
    expect(page).to have_content @shelter_1.name
    expect(page).to have_content @shelter_2.name
    expect(page).to have_content @shelter_3.name
    within '#shelters_pending_pets' do
      expect(page).to have_content @shelter_1.name
    end
  end

  it 'should approve pet on application' do
    app1 = Application.create! attributes_for(:application)
    pet1 = @shelter_1.pets.create attributes_for(:pet)
    app1.pets << pet1
    app1.status = :pending
    app1.save!
    visit "/admin/applications/#{app1.id}"
    expect(page).to have_link 'Approve', href: "/admin/applications/#{app1.id}/approve_pet/#{pet1.id}"
    click_on 'Approve'
    expect(page).to have_no_link 'Approve'
    expect(page).to have_content '✅ Approved'
  end

  it 'should reject pet on application' do
    app1 = Application.create! attributes_for(:application)
    pet1 = @shelter_1.pets.create attributes_for(:pet)
    app1.pets << pet1
    app1.status = :pending
    app1.save!
    visit "/admin/applications/#{app1.id}"
    expect(page).to have_link 'Reject', href: "/admin/applications/#{app1.id}/reject_pet/#{pet1.id}"
    click_on 'Reject'
    expect(page).to have_no_link 'Reject'
    expect(page).to have_content 'X Rejected'
  end

  it 'should decision on one app_pet does not affect other app with same pet' do
    approve = Application.create! attributes_for(:application)
    app = Application.create! attributes_for(:application)
    pet = @shelter_1.pets.create attributes_for(:pet)
    pet2 = @shelter_1.pets.create attributes_for(:pet)
    approve.pets << pet
    approve.pets << pet2
    approve.status = :pending
    approve.save!
    app.pets << pet
    app.status = :pending
    app.save!
    visit "/admin/applications/#{approve.id}"
    within "#pet-#{pet.id}"do
      click_on 'Approve'
    end
    visit "/admin/applications/#{app.id}"
    expect(page).to have_link 'Approve', href: "/admin/applications/#{app.id}/approve_pet/#{pet.id}"
    expect(page).to have_link 'Reject', href: "/admin/applications/#{app.id}/reject_pet/#{pet.id}"
  end

  it 'should be accepted if all pets are approved (all at once)' do
    app = Application.create! attributes_for(:application)
    3.times do
      pet = @shelter_1.pets.create! attributes_for(:pet)
      app.pets << pet
    end
    app.status = :pending
    app.save!
    visit "/admin/applications/#{app.id}"
    expect(page).to have_link 'Approve all pets', href: "/admin/applications/#{app.id}/approve_pets"
    click_link 'Approve all pets'
    expect(page).to have_current_path "/admin/applications/#{app.id}"
    expect(page).to have_no_link 'Approve all pets', href: "/admin/applications/#{app.id}/approve_pets"
    expect(page).to have_content 'Status: accepted'
  end

  it 'should be accepted if all pets are approved (one by one)' do
    app = Application.create! attributes_for(:application)
    pet = @shelter_1.pets.create! attributes_for(:pet)
    app.pets << pet
    app.status = :pending
    app.save!
    visit "/admin/applications/#{app.id}"
    within "#pet-#{pet.id}" do
      click_on 'Approve'
    end
    expect(page).to have_current_path "/admin/applications/#{app.id}"
    expect(page).to have_no_link 'Approve all pets', href: "/admin/applications/#{app.id}/approve_pets"
    expect(page).to have_content 'Status: accepted'
  end

  it 'should rejected app if one pet is rejected' do
    app = Application.create! attributes_for(:application)
    pet = @shelter_1.pets.create! attributes_for(:pet)
    app.pets << pet
    app.status = :pending
    app.save!
    visit "/admin/applications/#{app.id}"
    within "#pet-#{pet.id}" do
      click_on 'Reject'
    end
    expect(page).to have_current_path "/admin/applications/#{app.id}"
    expect(page).to have_no_link 'Approve all pets', href: "/admin/applications/#{app.id}/approve_pets"
    expect(page).to have_content 'Status: rejected'
  end

  it 'approved application makes pet no adoptable' do
    app = Application.create! attributes_for(:application)
    pet = @shelter_1.pets.create! attributes_for(:pet)
    app.pets << pet
    app.status = :pending
    app.save!
    visit "/admin/applications/#{app.id}"
    within "#pet-#{pet.id}" do
      click_on 'Approve'
    end
    visit "/pets/#{pet.id}"
    expect(page).to have_content 'Adoptable?: false'
  end

  it 'pets can only have one approved application on them at any time' do
    app1 = Application.create! attributes_for(:application)
    app2 = Application.create! attributes_for(:application)
    pet = @shelter_1.pets.create! attributes_for(:pet)
    app1.pets << pet
    app2.pets << pet
    app1.status = :pending
    app2.status = :pending
    app1.save!
    app2.save!
    visit "/admin/applications/#{app1.id}"
    within "#pet-#{pet.id}" do
      click_on 'Approve'
    end
    visit "/admin/applications/#{app2.id}"
    within '#pets' do
      expect(page).to have_content 'This pet has been approved for adoption.'
      expect(page).to have_no_link 'Approve', href: "/admin/applications/#{app2.id}/approve_pet/#{pet.id}"
      expect(page).to have_link 'Reject', href: "/admin/applications/#{app2.id}/reject_pet/#{pet.id}"
    end
  end
end