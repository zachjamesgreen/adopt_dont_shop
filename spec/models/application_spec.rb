require 'rails_helper'

RSpec.describe Application, type: :model do
  describe 'relationships' do
    it {should belong_to(:pet)}
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:street) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zip_code) }
    it { should validate_presence_of(:desc) }
  end

  describe 'enum' do
    it { should define_enum_for(:status).
      with_values(%w(in_progress pending accepted rejected)).backed_by_column_of_type(:enum) }

    it { should allow_values(:in_progress, :pending, :accepted, :rejected).for(:status) }
  end


end