class Movie < ApplicationRecord
  has_many :showings, dependent: :destroy
  has_many :theaters, through: :showings
  has_many :trailers, dependent: :destroy

  validates :title, presence: true
end
