class User < ApplicationRecord
  has_many :staff_favourites
  has_many :course_favourites
  has_many :project_favourites
  has_many :thesis_favourites
end
