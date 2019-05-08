class Showing < ApplicationRecord
  belongs_to :movie
  belongs_to :theater

  validates :play_date, :showtimes, presence: true

  scope :theater_on_date, ->(theater, date) { where(theater_id: theater.id, play_date: date) }
end
