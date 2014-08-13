class FrequencyAssignment < ActiveRecord::Base
  belongs_to :subject, polymorphic: true
  belongs_to :frequency
  belongs_to :uke_import   # to dotyczy wyłącznie subject == UkeStation

  delegate :display_name, to: :subject
end
