class Uke::Unifier
  def self.indexify_string(string)
    string.gsub(/[^0-9a-z]/i, '').gsub(/\s+/, '').downcase
  end
  
  def self.frq_string(string)
    string.to_s.strip.gsub(',', '.').gsub('*', '.').gsub('#', '.').to_f
  end
end