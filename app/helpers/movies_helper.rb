module MoviesHelper
  def normalize_times(time)
    time = Time.parse(time)
    time.strftime("%I:%M %p")
  end
end
