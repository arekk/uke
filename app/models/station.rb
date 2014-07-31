class Station < ActiveRecord::Base
  belongs_to :operator
  belongs_to :permit

  has_and_belongs_to_many :frequencies

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

  def tx_frequencies
    frequencies.where(:usage => 'TX')
  end

  def rx_frequencies
    frequencies.where(:usage => 'RX')
  end
end
