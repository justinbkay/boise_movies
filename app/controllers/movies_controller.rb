class MoviesController < ApplicationController
  def index
    @movies = Movie.where('showings.play_date': Date.today)
                   .eager_load(:showings)
                   .order(:title)
  end
end
