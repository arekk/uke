class ImportBandplan < ActiveRecord::Migration
  def up
    CSV.read("#{Rails.root.to_s}/db/migrate/20140811120438_import_bandplan.csv").each do |row|
      range = row[0].to_s
      purpose = row[1].to_s.strip.downcase

      step = row[4].to_s.strip.gsub(',', '.').to_f
      step = nil if step == 0

      description = row[5].to_s.strip

      first = range.split('-').first.strip.gsub(',', '.').to_f
      last =  range.split('-').last.strip.gsub(',', '.').to_f

      bandplan = Bandplan.new({mhz_start: first, mhz_end: last, step: step, purpose: purpose, description: description})
      bandplan.save!
    end

  end
end
