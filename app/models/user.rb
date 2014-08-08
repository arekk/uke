class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable
  validates :nickname, :presence => true, :length => {:maximum => 255}
end
