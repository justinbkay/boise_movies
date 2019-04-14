class Movie < ApplicationRecord
  has_many :showings

  validates :title, presence: true
end
