class FrequencyAssignment < ActiveRecord::Base
  belongs_to :subject, polymorphic: true
  belongs_to :frequency
end
