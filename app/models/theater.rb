class Theater < ApplicationRecord
  has_many :showings
  has_many :movies, through: :showings
end
