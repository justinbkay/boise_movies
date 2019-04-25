class Theater < ApplicationRecord
  has_many :showings
  has_many :movies, through: :showings
  validates :name, :imdb_name, presence: true
end
