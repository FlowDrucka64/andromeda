class CreateProjectFavourites < ActiveRecord::Migration[7.0]
  def change
    create_table :project_favourites do |t|
      t.belongs_to :user

      t.integer :project_id
      t.string :notes
      t.string :keywords

      t.timestamps
    end
  end
end
