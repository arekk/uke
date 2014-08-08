class Log < ActiveRecord::Base
  scope :my, lambda{|user| where(user_id: user.id)}

  validates :name, :presence => true, :length => {:maximum => 255}

  validates :administrative_area_level_3, :presence => true, :length => {:maximum => 255}
  validates :administrative_area_level_2, :presence => true, :length => {:maximum => 255}
  validates :administrative_area_level_1, :presence => true, :length => {:maximum => 255}
  validates :country, :presence => true, :length => {:maximum => 255}
  validates :lon, :presence => true, inclusion: { in: -180..180 }
  validates :lat, :presence => true, inclusion: { in: -90..90 }

  def display_location
    "#{street_address}"
  end
end

