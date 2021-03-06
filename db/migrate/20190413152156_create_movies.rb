class CreateMovies < ActiveRecord::Migration[6.0]
  def change
    create_table :movies do |t|
      t.string :title
      t.string :rating
      t.text :overview
      t.string :poster
      t.string :imdb_rating
      t.string :metascore
      t.integer :tmdb_id

      t.timestamps
    end
    add_index :movies, :tmdb_id, unique: true
  end
end
