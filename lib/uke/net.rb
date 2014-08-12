class Uke::Net
  def self.all
    %w(A C T F E D Q R B P)
  end

  def self.listenable
    %w(A C T)
  end

  def self.transmission_type(net)
    return :voice   if %w(A D Q R T).include?(net)
    return :digital if %w(B C E F P).include?(net)
    :other
  end

  def self.voice?(net)
    :voice == transmission_type(net)
  end

  def self.digital?(net)
    :digital == transmission_type(net)
  end
end