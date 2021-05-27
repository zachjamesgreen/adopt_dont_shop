require 'rails_helper'

RSpec.describe Application, type: :model do
  before do
    @shelter_1 = Shelter.create(attributes_for(:shelter))
    @pet_1 = @shelter_1.pets.create(attributes_for(:pet))
    @pet_2 = @shelter_1.pets.create(attributes_for(:pet))
    @pet_3 = @shelter_1.pets.create(attributes_for(:pet))
  end

  describe 'relationships' do
    it { is_expected.to have_many(:pets).through(:application_pets) }
    # it { should have_many(:application_pets) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:street) }
    it { is_expected.to validate_presence_of(:city) }
    it { is_expected.to validate_presence_of(:state) }
    it { is_expected.to validate_presence_of(:zip_code) }
    # it { should validate_presence_of(:desc) }
  end

  describe 'enum' do
    it {
      expect(subject).to define_enum_for(:status)
        .with_values({ in_progress: 'in_progress', pending: 'pending', accepted: 'accepted', rejected: 'rejected' })
        .backed_by_column_of_type(:enum)
    }

    it { is_expected.to allow_values(:in_progress, :pending, :accepted, :rejected).for(:status) }
  end

  describe '#get_pets_not_on_app' do
    it 'gets all pets not on an application' do
      app = Application.create! attributes_for(:application)
      app.pets << @pet_1
      expect(app.get_pets_not_on_app).to match_array([@pet_2, @pet_3])
    end
  end
end
