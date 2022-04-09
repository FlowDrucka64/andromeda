class CreateThesisFavourites < ActiveRecord::Migration[7.0]
  def change
    create_table :thesis_favourites do |t|
      t.belongs_to :user

      t.integer :thesis_id
      t.integer :dsw_id
      t.integer :dsr_id
      t.string :notes
      t.string :keywords

      t.timestamps
    end
  end
end
