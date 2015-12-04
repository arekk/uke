class User < ActiveRecord::Base
  has_many :logs
  has_many :log_entries

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable
  validates :nickname, :presence => true, :length => {:maximum => 255}
end
