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
			if res.is_a?(Net::HTTPSuccess)
				body = JSON.parse(res.body)

				if body["Released"]
					movie.update_attribute(:released, body["Released"])
				end
				if body["Ratings"]
					rotten_tomatoes = body["Ratings"].find {|r| r["Source"] == "Rotten Tomatoes" }
				end
				if body["BoxOffice"]
					movie.update_attribute(:box_office, body["BoxOffice"])
				end
				if movie.overview.blank?
					movie.update_attribute(:overview, body["Plot"])
				end
				if movie.metascore.blank? && body["Metascore"]
					movie.update_attribute(:metascore, body["Metascore"])
				end
				movie.update_attribute(:runtime, body["Runtime"])
				movie.update_attribute(:genre, body["Genre"])
				if rotten_tomatoes
				  movie.update_attribute(:rotten_tomatoes, rotten_tomatoes["Value"])
				end

				get_tmdb_info(movie)
			end
		end
	end

	def get_tmdb_info(movie)
		uri = URI("https://api.themoviedb.org/3/find/#{movie.imdb_id}?api_key=#{Rails.application.credentials.tmdb_key}&language=en-US&external_source=imdb_id")
			res = Net::HTTP.get_response(uri)
			if res.is_a?(Net::HTTPSuccess)
				body = JSON.parse(res.body)
				movie_id = body["movie_results"][0]["id"]
				get_trailers(movie_id, movie)
			end
	end

	def get_trailers(id, movie)
		uri = URI("https://api.themoviedb.org/3/movie/#{id}/videos?api_key=#{Rails.application.credentials.tmdb_key}&language=en-US")
			res = Net::HTTP.get_response(uri)
			if res.is_a?(Net::HTTPSuccess)
				body = JSON.parse(res.body)
				body["results"].filter {|video| video["type"] == "Trailer" && video["official"] == true && !video["name"].include?("English Subtitled")}.each do |trailer|
					begin
						Trailer.create(
							movie_id: movie.id,
							name: trailer["name"],
							site: trailer["site"],
							key: trailer["key"]
						)
					rescue
						puts "duplicate trailer"
					end
				end
			end
	end
end