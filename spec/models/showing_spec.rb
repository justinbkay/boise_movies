require 'rails_helper'

RSpec.describe Showing, type: :showing do
  it 'requires a play_date to be valid' do
    movie = Movie.new
    movie.showings << Showing.new(play_date: Date.today, showtimes: ['7:00pm', '9:00pm'])
    showing = movie.showings.first
    expect(showing.valid?).to eq(true)
  end
end