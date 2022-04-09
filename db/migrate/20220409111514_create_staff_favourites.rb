class CreateStaffFavourites < ActiveRecord::Migration[7.0]
  def change
    create_table :staff_favourites do |t|
      t.belongs_to :user

      t.integer :staff_id
      t.string :notes
      t.string :keywords

      t.timestamps
    end
  end
end



