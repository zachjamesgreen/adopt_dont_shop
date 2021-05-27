require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ApplicationsHelper. For example:
#
# describe ApplicationsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ApplicationsHelper, type: :helper do
  it 'returns enum type as array' do
    expected = [
      ['In progress', 'in_progress'],
      %w[Pending pending],
      %w[Accepted accepted],
      %w[Rejected rejected]
    ]
    expect(helper.get_statuses).to eq expected
  end
end
