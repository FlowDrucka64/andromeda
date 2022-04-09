class CreateCourseFavourites < ActiveRecord::Migration[7.0]
  def change
    create_table :course_favourites do |t|
      t.belongs_to :user

      t.integer :course_number
      t.integer :dsw_id
      t.integer :dsr_id
      t.string :semester
      t.string :notes
      t.string :keywords

      t.timestamps
    end
  end
end
