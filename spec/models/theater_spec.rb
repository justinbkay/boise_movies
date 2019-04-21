require 'rails_helper'

RSpec.describe Theater, type: :model do
  it { should have_many(:showings) }
  it { should have_many(:movies).through(:showings)}
end
