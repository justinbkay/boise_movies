require 'rails_helper'

RSpec.describe Showing, type: :showing do
  it 'requires a play_date to be valid' do
    theater = create(:theater)
    movie = Movie.new
    movie.showings << Showing.new(theater: theater, play_date: Date.current, showtimes: ['7:00pm', '9:00pm'])
    showing = movie.showings.first
    expect(showing.valid?).to eq(true)
  end

  it 'requires showtimes to be valid' do
    theater = create(:theater)
    movie = Movie.new
    showing = Showing.new(theater: theater, play_date: Date.current)
    expect(showing.valid?).to eq(false)
    expect(showing.errors[:showtimes]).to include("can't be blank")
  end
end