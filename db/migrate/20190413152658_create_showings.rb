class CreateShowings < ActiveRecord::Migration[6.0]
  def change
    create_table :showings do |t|
      t.references :movie, foreign_key: true
      t.date :play_date
      t.string :showtimes, array: true

      t.timestamps
    end
  end
end
