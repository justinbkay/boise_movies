class CreateTrailers < ActiveRecord::Migration[6.1]
  def change
    create_table :trailers do |t|
      t.string :name
      t.string :site
      t.string :key
      t.references :movie, null: false, foreign_key: true

      t.timestamps
    end
  end
end
