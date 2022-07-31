class MakeTrailerKeyUnique < ActiveRecord::Migration[6.1]
  def change
    Trailer.delete_all

    add_index :trailers, :key, unique: true
  end
end
