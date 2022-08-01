module MoviesHelper
  def normalize_times(time)
    time = Time.parse(time)
    time.strftime('%I:%M')
  end

  def find_meridian(time)
    m = time.match(/(\d+):(\d+)\s*(\w*)/)
    m[3].empty? ? 'pm' : m[3].downcase
  end

  def show_trailer_pluralize(count)
    if count == 1
      "Show Trailer"
    else
      "Show Trailers"
    end
  end
end
