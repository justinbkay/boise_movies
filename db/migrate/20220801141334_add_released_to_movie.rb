class AddReleasedToMovie < ActiveRecord::Migration[6.1]
  def change
    add_column :movies, :released, :string
  end
end
