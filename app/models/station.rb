class Station < ActiveRecord::Base
  belongs_to :operator
  belongs_to :permit

  has_and_belongs_to_many :frequencies

  delegate :name, :address, to: :operator, prefix: true

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
