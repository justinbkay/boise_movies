class MoviesController < ApplicationController
  def index
    @movies = Movie.where('showings.play_date': Date.current)
                   .eager_load(:showings)
                   .order(:title)

    @count_by_rating = make_count(@movies)
  end

  private

  def make_count(movies)
    movies.inject({}) do |acc, m|
      acc.key?(m.rating) ? acc[m.rating] += 1 : acc[m.rating] = 1
      acc
    end
  end
end
