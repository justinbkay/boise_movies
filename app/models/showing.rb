class Showing < ApplicationRecord
  belongs_to :movie

  validates :play_date, :showtimes, presence: true
end
