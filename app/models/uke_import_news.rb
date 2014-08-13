class UkeImportNews < ActiveRecord::Base
  belongs_to :uke_import
  belongs_to :uke_station
end
