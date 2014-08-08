class Uke::Unifier
  def self.indexify_string(string)
    string.gsub(/[^0-9a-z]/i, '').gsub(/\s+/, '').downcase
  end
end