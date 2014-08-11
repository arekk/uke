class LogEntry < ActiveRecord::Base
  belongs_to :user
  belongs_to :log
  has_one :frequency_assignment, as: :subject

  attr_accessor :mhz

  scope :my, lambda{|user| where(user_id: user.id)}
end
