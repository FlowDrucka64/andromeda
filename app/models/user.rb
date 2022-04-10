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

  def staff_favourites_objects
    objects = []
    self.staff_favourites.each do |f|
      p = fetch_staff(f.staff_id)
      #p = {"prefixTitle"=>"seife","firstname"=>"test","lastname"=>"debug","id"=>f.staff_id}
      #TODO: add staff_favourite information to object here (notes, keywords)
      objects = objects.push(p) if p
    end
    return objects
  end

  def fetch_staff(id)
    url = Rails.configuration.staff_base_url + id.to_s
    response = Excon.get(url)
    return nil if response.status != 200
    Hash.from_xml(response.body)["tuvienna"]["person"]
  end
end
