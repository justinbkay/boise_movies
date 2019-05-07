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
                           poster: page2[:poster]) unless movie
      movie.showings << Showing.new(theater_id: 1, play_date: Date.today, showtimes: times)
    end
  end


  desc 'scrape imdb'
  task imdb: :environment do
    url = 'https://www.imdb.com/showtimes/location/US/83702'
    user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36"
    page = Nokogiri::HTML(open(url, { "User-Agent" => user_agent }))
    date = Date.today

    movies = page.css('.lister-item.mode-grid')

    movies.each do |movie|
      puts title = movie.css('span[name=alpha]').attribute('data-value').value
      puts user_rating = movie.css('span[name=user_rating]').attribute('data-value').value
      puts rating = movie.css('span.certificate').text
      puts metascore = movie.css('span.metascore').text
      puts description = movie.css('.ratings-bar + p').text
      puts movie.css('.lister-item-image > a').attribute('href').value =~ /(tt[0-9]+)/
      puts
      imdb_id = $1

      movie = Movie.where(title: title).first
      movie ||= Movie.create(title: title,
                             overview: description,
                             rating: rating,
                             imdb_rating: user_rating,
                             metascore: metascore)

      page2 = Nokogiri::HTML(open('https://www.imdb.com/showtimes/title/' + imdb_id + '/US/83634', { "User-Agent" => user_agent }))
      theaters = page2.css('.list_item')
      theaters.each do |theater|
        puts theatre = theater.css('.fav_box > h3 > a > span').text
        puts showtimes = theater.css('.showtimes a.showtimes-ticketing-link').map(&:text)
        puts img = page2.css('.poster.shadowed').attribute('src').value
        movie.update_attribute(:poster, img)
        next unless Theater.where(imdb_name: theatre.strip).presence

        theater = Theater.where(imdb_name: theatre.strip).first
        movie.showings.where(play_date: date, theater_id: theater.id).destroy_all
        movie.showings << Showing.new(theater_id: theater.id,
                                      play_date: date,
                                      showtimes: showtimes)
      end
      page3 = Nokogiri::HTML(open('https://www.imdb.com/title/' + imdb_id + '/?ref_=shtt_ov_i'))
      begin
      puts img = page3.css('img.pswp__img').attribute('src').value
      movie.update_attribute(:poster, img)
      rescue
        puts movie.title
      end
    end
  end

  desc 'scrape imdb mobile'
  task imdb_mobile: :environment do
    date = Date.today
    user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36"
    # page = Nokogiri::HTML(open("https://m.imdb.com/showtimes/movies?date=#{date}&zip=83706&country=US", { "User-Agent" => "#{user_agent}" }))
    page = open("https://m.imdb.com/showtimes/movies?date=2019-05-04&zip=83706&country=US")
    movies = page.css('a.ipl-block-link')
    movies.each_cons(2) do |grp|
      @title = grp[0].css('.ipl-detail-block__title').text.strip
      next if @title.blank?
      @rating = grp[0].css('div.showtimes-title-metadata > ul > li:nth-child(3)').inner_html
      @imdb_score = grp[0].css('.ipl-user-rating__label').text
      @metascore = grp[0].css('.ipl-metascore__score').text
      if @title.present?
        movie = Movie.where(title: @title).first
        movie = Movie.create(title: @title,
                             rating: @rating,
                             imdb_rating: @imdb_score,
                             metascore: @metascore) unless movie
      end
      # puts movie.inspect
      showtimes_href = grp[1].attribute('href')
      imdb_id = /\/(tt.+)/.match(showtimes_href)[1]
      showtimes = "/showtimes/title/#{imdb_id}?date=#{date}&zip=83706&country=US"

      # then follow this link
      page2 = Nokogiri::HTML(open("https://m.imdb.com#{showtimes}"))
      showtimeresults = page2.css('.showtimes-results')
      showtimeresults.each do |sec|
        theaters = sec.css('.showtimes-theater-detail-block__header').map(&:text)
        showtimes_array = sec.css('.ipl-block-link + ul')
        (0..theaters.size - 1).each do |iter|
          puts theaters[iter]
          if Theater.where(imdb_name: theaters[iter].strip).presence
            theater = Theater.where(imdb_name: theaters[iter].strip).first
            movie.showings.where(play_date: date, theater_id: theater.id).destroy_all
            movie.showings << Showing.new(theater_id: theater.id,
                                          play_date: date,
                                          showtimes: showtimes_array[iter].css('li a').map(&:text))
          end
        end
      end
    end
  end

  def get_detail(link)
    page2 = Nokogiri::HTML(open("http://meridian.hallettcinemas.com/#{link}"))
    rating = fix_rating(page2.css('table.right_nowshowing > tr:nth-child(2) > td:nth-child(3)').children.first.text.strip)
    poster = page2.css('#mposter > img').attribute('src').value
    summary = page2.xpath('//td[contains(text(), "Synopsis")]').first.parent.css('td').children[1].text
    {rating: rating, poster: poster, summary: summary}
  end

  def fix_rating(rating)
    rating == 'PG13' ? 'PG-13' : rating
  end

end