class Trailer < ApplicationRecord
  belongs_to :movie, touch: true
end
