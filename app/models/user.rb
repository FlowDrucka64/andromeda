# User model used to store User objects which can have many staff/course/project/thesis favourites
class User < ApplicationRecord
  has_many :staff_favourites
  has_many :course_favourites
  has_many :project_favourites
  has_many :thesis_favourites

  validates :username, uniqueness: true # make sure the username is unique
  validates_confirmation_of :password # make sure password has been confirmed

  # Welcome message displayed when user is successfully logged in
  def welcome
    "Hello, #{self.username}!"
  end
end
