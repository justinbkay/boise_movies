class MoviesController < ApplicationController
  def index
    @movies = Movie.order(:title)
  end
end
