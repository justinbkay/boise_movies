class Movie < ApplicationRecord
  has_many :showings, dependent: :destroy
  has_many :theaters, through: :showings

  validates :title, presence: true
end
