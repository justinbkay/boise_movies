require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the MoviesHelper. For example:
#
# describe MoviesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe MoviesHelper, type: :helper do
  describe 'normalize_times' do
    it 'puts times into a standard format' do
      expect(helper.normalize_times('1:30 pm')).to eq('01:30 PM')
    end
  end
end
