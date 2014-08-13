def putsnb(s)
  puts Time.now.strftime("%H:%M:%S") + ': ' + s
  $stdout.flush
end

def geo2dec(pos)
  # pozycję mamy w formacie: 18E47'13"
  deg = m = s = ''
  found_dir = found_min = found_sec = nil

  pos.chars.each do |char|
    if ['E', 'W', 'S', 'N'].include?(char) && found_dir.nil?
      found_dir = char
      next
    end
    if "'" == char
      found_min = true
      next
    end
    if '"' == char
      found_sec = true
      next
    end

    deg = deg + char if found_dir.nil?
    m = m + char if found_dir && found_min.nil?
    s = s + char if found_dir && found_min && found_sec.nil?
  end

  deg.to_f + (m.to_f * 1/60) + (s.to_f * 1/60 * 1/60)
end

def row2hash(row)
  #0 : Nr referencyjny
  #1 : Ważna do
  #2 : Nazwa stacji
  #3 : Rodz stacji
  #4 : Rodz sieci
  #5 : Dł geo
  #6 : Szer geo
  #7 : R obsł
  #8 : Lokalizacja stacji
  #9 : ERP
  #10: Azymut
  #11: Elewacja
  #12: Polar
  #13: Zysk ant
  #14: H anteny
  #15: H terenu
  #16: Ch-ka poz
  #17: Ch-ka pion
  #18: Częstotliwości nadawcze
  #19: Częstotliwości odbiorcze
  #20: Szer kanałów nad
  #21: Szer kanałów odb
  #22: Operator
  #23: Adres operatora
  h = {
    permit: {
      number:     row[0],
      valid_to:   row[1]
    },

    station: {
      name:             row[2],
      purpose:          row[3],
      net:              row[4],
      lon:              geo2dec(row[5]).round(6),
      lat:              geo2dec(row[6]).round(6),
      radius:           row[7] ? row[7].to_i : nil,
      location:         row[8],
      erp:              row[9].to_f.round(1),
      ant_efficiency:   row[13].to_f.round(1),
      ant_height:       row[14].to_i,
      ant_polarisation: row[12],
      directional:      (row[10].strip == '' ? false : true),
      name_unified:     Uke::Unifier::indexify_string(row[2] + row[8])
    },

    frq_tx:     row[18].gsub(/\s+/, '').split(',').map{|frq| frq.to_f}.keep_if{|frq| frq > 0},
    frq_rx:     row[19].gsub(/\s+/, '').split(',').map{|frq| frq.to_f}.keep_if{|frq| frq > 0},

    operator: {
      name:     row[22],
      address:  row[23],
      name_unified: Uke::Unifier::indexify_string(row[22])
    }
  }
end

def insert_row(row, uke_import)
  permit = UkePermit.find_by_number row[:permit][:number]
  permit = UkePermit.create! row[:permit] if permit.nil?

  operator = UkeOperator.find_by_name_unified row[:operator][:name_unified]
  operator = UkeOperator.create! row[:operator] if operator.nil?

  any_news = false
  station = UkeStation.where(name_unified: row[:station][:name_unified], uke_operator: operator).first

  if station.nil?
    any_news = true
    station = UkeStation.new row[:station]
    station.uke_operator = operator
  end

  station.uke_import = uke_import
  station.uke_permit = permit
  station.save!

  row[:frq_rx].each do |mhz|
    frequency = Frequency.find_or_create_by!(mhz: mhz)
    if (frequency_assignment = station.frequency_assignments.where(usage: 'RX', frequency: frequency).first).nil?
      station.frequency_assignments << FrequencyAssignment.new(frequency: frequency, usage: 'RX', uke_import: uke_import)
      any_news = true
    else
      frequency_assignment.uke_import = uke_import
    end
  end

  row[:frq_tx].each do |mhz|
    frequency = Frequency.find_or_create_by!(mhz: mhz)
    if (frequency_assignment = station.frequency_assignments.where(usage: 'TX', frequency: frequency).first).nil?
      station.frequency_assignments << FrequencyAssignment.new(frequency: frequency, usage: 'TX', uke_import: uke_import)
      any_news = true
    else
      frequency_assignment.uke_import = uke_import
    end
  end

  if any_news && UkeImportNews.where(uke_import: uke_import, uke_station: station).first.nil?
    UkeImportNews.create(uke_import: uke_import, uke_station: station)
    putsnb "News on station #{station.display_name}"
  end
end

ARGV.each do|a|
  putsnb "Argument: #{a}"
  @import_release_date = a.sub(/--release-date=/, '').to_s unless (a =~ /--release-date=/).nil?
end

if @import_release_date.nil?
  putsnb "Give UKE database release date as --release-date= argument"
  exit
end

@uke_import = UkeImport.find_by_released_on(Date.parse(@import_release_date))
if @uke_import.nil?
  putsnb "Release not found, please create one using ss_import_create.rb"
  exit
end

putsnb "UKE import release #{@uke_import.id}/#{@uke_import.released_on.to_s}"

Dir["#{Rails.root.to_s}/tmp/ss/#{@import_release_date}/*"].each do |xls_file|
  putsnb "File #{xls_file}\n"

  book = Spreadsheet.open(xls_file, 'rb')
  sheet = book.worksheet(0)
  first = true
  sheet.each do |row|
    if first
      first = false
    else
      begin
        insert_row(row2hash(row), @uke_import)
      rescue => e
        puts e.to_s
        puts row2hash(row).inspect
      end
    end
  end
end

UkeImport.all.each do |uke_import|
  uke_import.active = false
  uke_import.save!
end

uia = UkeImport.find(@uke_import.id)
uia.active = true
uia.save!

putsnb "Done"