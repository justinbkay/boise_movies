module MoviesHelper
  def normalize_times(time)
    time = Time.parse(time)
    time.strftime('%I:%M')
  end

  def find_meridian(time)
    m = time.match(/(\d+):(\d+)\s*(\w*)/)
    m[3].empty? ? 'pm' : m[3].downcase
  end
end
