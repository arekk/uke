class UkeImport < ActiveRecord::Base
  has_many :uke_stations
  has_many :frequency_assignments
end
