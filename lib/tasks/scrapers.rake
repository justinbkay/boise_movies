require 'nokogiri'
require 'open-uri'

namespace :scrapers do
  desc 'get now playing'
  task now_playing: :environment do
    NowPlaying.delete_all
    Tmdb::Api.key(Rails.application.credentials.tmdb[:api_key])
    page_1 = Tmdb::Movie.now_playing(region: 'US')
    results = page_1.results
    pages = page_1.total_pages
    (2..pages).each do |p|
      page = Tmdb::Movie.now_playing(region: 'US', page: p)
      results << page.results
    end
    results.flatten.each do |r|
      next if r.adult == 'true'
      # begin
      # puts r.id.inspect
      # rescue
      #   debugger
      # end
      id = r.id.is_a?(Integer) ? r.id : r.first.id
      mo = Tmdb::Movie.releases(id, language: 'US')
      ratings = ['G', 'PG', 'PG-13', 'R']
      rating = mo.find { |i| ratings.include?(i&.certification) }&.certification
      NowPlaying.create(tmdb_id: id,
                        title: r.title,
                        rating: rating,
                        popularity: r.popularity,
                        poster_path: r.poster_path,
                        backdrop_path: r.backdrop_path,
                        overview: r.overview,
                        release_date: Date.parse(r.release_date))
    end
  end

  desc 'scrape movies for Majestic Cinemas'
  task majestic: :environment do
    Showing.delete_all
    Movie.delete_all
    page = Nokogiri::HTML(open("http://meridian.hallettcinemas.com/"))

    movies = page.css('li.movieli')

    movies.each do |m|
      title_link = m.css('#hpMtitle > a')#.attribute('href').value
      next if title_link.empty?

      title = title_link.text
      link = title_link.attribute('href').value
      times = m.css('div.hpTimes > a').map(&:text)
      page2 = get_detail(link)
      movie = Movie.create(title: title,
                           rating: page2[:rating],
                           overview: page2[:summary],
                           poster: page2[:poster])
      movie.showings << Showing.new(theater_id: 1, play_date: Date.today, showtimes: times)
    end
  end

  def get_detail(link)
    page2 = Nokogiri::HTML(open("http://meridian.hallettcinemas.com/#{link}"))
    rating = page2.css('table.right_nowshowing > tr:nth-child(2) > td:nth-child(3)').children.first.text
    poster = page2.css('#mposter > img').attribute('src').value
    summary = page2.xpath('//td[contains(text(), "Synopsis")]').first.parent.css('td').children[1].text
    {rating: rating, poster: poster, summary: summary}
  end
end