require 'nokogiri'
require 'open-uri'

namespace :scrapers do
  desc 'scrape movies for Majestic Cinemas'
  task majestic: :environment do
    page = Nokogiri::HTML(open("http://meridian.hallettcinemas.com/"))

    movies = page.css('li.movieli')

    movies.each do |m|
      title = m.css('#hpMtitle > a').text
      times = m.css('div.hpTimes > a').map { |t| t.text }

      movie = Movie.create(title: title)
      movie.showings << Showing.new(play_date: Date.today, showtimes: times)
    end
  end
end