class Showing < ApplicationRecord
  belongs_to :movie
  belongs_to :theater

  validates :play_date, :showtimes, presence: true
end
