class AddImdbIdToMovie < ActiveRecord::Migration[6.1]
  def change
    add_column :movies, :imdb_id, :string
    add_column :movies, :runtime, :string
    add_column :movies, :rotten_tomatoes, :string
    add_column :movies, :genre, :string
  end
end
