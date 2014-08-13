class Bandplan < ActiveRecord::Base
  def self.find_by_mhz(mhz)
    mhz = Uke::Unifier::frq_string(mhz)
    self.where('? BETWEEN mhz_start AND mhz_end', mhz).first
  end

  def display_name
    description
  end
end
