class UkeStation < ActiveRecord::Base
  belongs_to :uke_operator
  belongs_to :uke_permit

  has_many :frequency_assignments, as: :subject
  has_many :frequencies, through: :frequency_assignments
  has_many :tx_frequencies, -> {where 'frequency_assignments.usage = "TX"'}, through: :frequency_assignments, source: :frequency
  has_many :rx_frequencies, -> {where 'frequency_assignments.usage = "RX"'}, through: :frequency_assignments, source: :frequency

  delegate :name, :address, to: :operator, prefix: true

  def transmission_type
    return :voice   if ['A', 'D', 'Q', 'R', 'T'].include?(net)
    return :digital if ['B', 'C', 'E', 'F', 'P'].include?(net)
    :other
  end

  def voice?
    :voice == transmission_type
  end

  def digital?
    :digital == transmission_type
  end

  def display_name
    "#{operator.name}: #{name}, #{location}"
  end
end
