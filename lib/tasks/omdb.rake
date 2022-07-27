require 'json'
require 'uri'
require 'net/http'

namespace :omdb do
  desc 'get now playing'
  task get_movie_data: :environment do
		movies = Movie.all
		movies.each do |movie|
			uri = URI("https://www.omdbapi.com/?i=#{movie.imdb_id}&apikey=ce280a8f")
			res = Net::HTTP.get_response(uri)
			body = JSON.parse(res.body)
			if body["Ratings"]
				rotten_tomatoes = body["Ratings"].find {|r| r["Source"] == "Rotten Tomatoes" }
			end
			if res.is_a?(Net::HTTPSuccess)
				movie.update_attribute(:runtime, body["Runtime"])
				movie.update_attribute(:genre, body["Genre"])
				if rotten_tomatoes
				  movie.update_attribute(:rotten_tomatoes, rotten_tomatoes["Value"])
				end
			end
		end
	end
end