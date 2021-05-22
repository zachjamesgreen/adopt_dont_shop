require 'rails_helper'

RSpec.describe Application, type: :model do
  describe 'relationships' do
    it { should have_many(:pets).through(:application_pets) }
    # it { should have_many(:application_pets) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:street) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zip_code) }
    # it { should validate_presence_of(:desc) }
  end

  before(:each) do
    @shelter_1 = Shelter.create(attributes_for(:shelter))
    @pet_1 = @shelter_1.pets.create(attributes_for(:pet))
    @pet_2 = @shelter_1.pets.create(attributes_for(:pet))
    @pet_3 = @shelter_1.pets.create(attributes_for(:pet))
  end

  describe 'enum' do
    it { should define_enum_for(:status).
        with_values({in_progress: 'in_progress', pending: 'pending', accepted: 'accepted', rejected: 'rejected'}).
        backed_by_column_of_type(:enum)
    }

    it { should allow_values(:in_progress, :pending, :accepted, :rejected).for(:status) }
  end

  describe '#get_pets_not_on_app' do
    it 'should get all pets not on an application' do
      app = Application.create! attributes_for(:application)
      app.pets << @pet_1
      expect(app.get_pets_not_on_app).to match_array([@pet_2, @pet_3])
    end
  end


end