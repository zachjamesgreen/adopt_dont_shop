require 'rails_helper'

RSpec.describe Pet, type: :model do
  before do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 3, adoptable: false)
  end

  describe 'relationships' do
    it { is_expected.to belong_to(:shelter) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:age) }
    it { is_expected.to validate_numericality_of(:age) }
  end

  describe 'class methods' do
    describe '#search' do
      it 'returns partial matches' do
        expect(Pet.search('Claw')).to eq([@pet_2])
      end
    end

    describe '#adoptable' do
      it 'returns adoptable pets' do
        expect(Pet.adoptable).to eq([@pet_1, @pet_2])
      end
    end
  end

  describe 'instance methods' do
    describe '.shelter_name' do
      it 'returns the shelter name for the given pet' do
        expect(@pet_3.shelter_name).to eq(@shelter_1.name)
      end
    end
  end

  describe '#approved?' do
    it 'returns approved pets' do
      app = Application.create! attributes_for(:application)
      app.pets << [@pet_1, @pet_2, @pet_3]
      ap = ApplicationPet.find_by application_id: app.id, pet_id: @pet_1.id
      ap.status = true
      ap.save!
      ap = ApplicationPet.find_by application_id: app.id, pet_id: @pet_3.id
      ap.status = false
      ap.save!
      expect(@pet_1.approved?(app)).to be true
      expect(@pet_2.approved?(app)).to be nil
      expect(@pet_3.approved?(app)).to be false
    end
  end

  describe '#accepted?' do
    it 'returns true if the pet is a part of an accepted application' do
      app = Application.create! attributes_for(:application)
      app.pets << @pet_1
      app.status = :accepted
      app.save!
      expect(@pet_1.accepted?).to be true
    end
  end
end
