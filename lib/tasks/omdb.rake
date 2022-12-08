require 'json'
require 'uri'
require 'net/http'

namespace :omdb do
  desc 'get now playing'
  task get_movie_data: :environment do
    movies = Movie.all
    movies.each do |movie|
      uri = URI("https://www.omdbapi.com/?i=#{movie.imdb_id}&apikey=#{Rails.application.credentials.omdb_key}")
      res = Net::HTTP.get_response(uri)
      next unless res.is_a?(Net::HTTPSuccess)

      body = JSON.parse(res.body)

      movie.update_attribute(:released, body['Released']) if body['Released']
      rotten_tomatoes = body['Ratings'].find { |r| r['Source'] == 'Rotten Tomatoes' } if body['Ratings']
      movie.update_attribute(:box_office, body['BoxOffice']) if body['BoxOffice']
      movie.update_attribute(:overview, body['Plot']) if movie.overview.blank?
      movie.update_attribute(:metascore, body['Metascore']) if movie.metascore.blank? && body['Metascore']
      movie.update_attribute(:runtime, body['Runtime'])
      movie.update_attribute(:genre, body['Genre'])
      movie.update_attribute(:rotten_tomatoes, rotten_tomatoes['Value']) if rotten_tomatoes

      get_tmdb_info(movie)
    end
  end

  def get_tmdb_info(movie)
    uri = URI("https://api.themoviedb.org/3/find/#{movie.imdb_id}?api_key=#{Rails.application.credentials.tmdb_key}&language=en-US&external_source=imdb_id")
    res = Net::HTTP.get_response(uri)
    if res.is_a?(Net::HTTPSuccess)
      body = JSON.parse(res.body)
      movie_id = body['movie_results'][0]['id']
      get_trailers(movie_id, movie)
    end
  rescue NoMethodError
    puts 'NO TRAILERS'
  end

  def get_trailers(id, movie)
    uri = URI("https://api.themoviedb.org/3/movie/#{id}/videos?api_key=#{Rails.application.credentials.tmdb_key}&language=en-US")
    res = Net::HTTP.get_response(uri)
    if res.is_a?(Net::HTTPSuccess)
      body = JSON.parse(res.body)
      body['results'].filter do |video|
        video['type'] == 'Trailer' && video['official'] == true && !video['name'].include?('English Subtitled')
      end.each do |trailer|
        Trailer.create(
          movie_id: movie.id,
          name: trailer['name'],
          site: trailer['site'],
          key: trailer['key']
        )
      rescue StandardError
        puts 'duplicate trailer'
      end
    end
  end
end
