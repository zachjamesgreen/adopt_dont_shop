# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Veterinarian, type: :model do
  before do
    @vet_office = VeterinaryOffice.create(name: 'Best Vets', boarding_services: true, max_patient_capacity: 20)
    @vet_1 = @vet_office.veterinarians.create(name: 'Taylor', review_rating: 10, on_call: true)
    @vet_2 = @vet_office.veterinarians.create(name: 'Tanya', review_rating: 9, on_call: true)
    @vet_3 = @vet_office.veterinarians.create(name: 'Jim', review_rating: 8, on_call: true)
    @not_on_call_vet = @vet_office.veterinarians.create(name: 'Sam', review_rating: 10, on_call: false)
  end

  describe 'relationships' do
    it { is_expected.to belong_to(:veterinary_office) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:review_rating) }
    it { is_expected.to validate_numericality_of(:review_rating) }
  end

  describe 'class methods' do
    describe '#search' do
      it 'returns partial matches' do
        expect(described_class.search('Ta')).to eq([@vet_1, @vet_2])
      end
    end

    describe '#on_call' do
      it 'returns on call veterinarians' do
        expect(described_class.on_call).to eq([@vet_1, @vet_2, @vet_3])
      end
    end
  end

  describe 'instance methods' do
    describe '.office_name' do
      it 'returns the veterinary_office name for the given vet' do
        expect(@vet_1.office_name).to eq(@vet_office.name)
      end
    end
  end
end
