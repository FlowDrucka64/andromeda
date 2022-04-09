class User < ApplicationRecord
  has_many :staff_favourites
  has_many :course_favourites
  has_many :project_favourites
  has_many :thesis_favourites

  validates :username, uniqueness: true
  validates_confirmation_of :password

  def welcome
    "Hello, #{self.username}!"
  end
end
