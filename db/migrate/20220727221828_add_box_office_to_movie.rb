class AddBoxOfficeToMovie < ActiveRecord::Migration[6.1]
  def change
    add_column :movies, :box_office, :string
  end
end
