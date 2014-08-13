class UkeStation < ActiveRecord::Base
  belongs_to :uke_operator
  belongs_to :uke_permit
  belongs_to :uke_import

  has_many :frequency_assignments, as: :subject

  has_many :frequencies, through: :frequency_assignments
  has_many :tx_frequencies, -> {where 'frequency_assignments.usage = "TX"'}, through: :frequency_assignments, source: :frequency
  has_many :rx_frequencies, -> {where 'frequency_assignments.usage = "RX"'}, through: :frequency_assignments, source: :frequency

  delegate :name, :address, to: :operator, prefix: true

  def transmission_type
    Uke::Net::transmission_type(net)
  end

  def voice?
    Uke::Net::voice?(net)
  end

  def digital?
    Uke::Net::digital?(net)
  end

  def source
    'UKE'
  end

  def display_name
    "#{uke_operator.name}: #{name}, #{location}"
  end
end
