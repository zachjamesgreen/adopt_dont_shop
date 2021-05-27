require 'rails_helper'

RSpec.describe ApplicationPet, type: :model do
  describe 'relationships' do
    it { is_expected.to belong_to(:pet) }
    it { is_expected.to belong_to(:application) }
  end
end
