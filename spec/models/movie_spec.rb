require 'rails_helper'

RSpec.describe Movie, type: :model do
  it 'requires a title to be valid' do
    movie = Movie.new
    expect(movie.valid?).to eq(false)

    expect(movie.errors[:title]).to include("can't be blank")
  end
end