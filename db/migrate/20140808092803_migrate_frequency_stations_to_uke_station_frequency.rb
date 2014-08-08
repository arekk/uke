class MigrateFrequencyStationsToUkeStationFrequency < ActiveRecord::Migration
  def up
    records = ActiveRecord::Base.connection.select_all('SELECT * FROM frequencies_stations')
    records.each do |record|
      frequency = Frequency.find record['frequency_id']
      uke_station = UkeStation.find record['station_id']
      uke_station.frequency_assignments << FrequencyAssignment.new(frequency: frequency, usage: frequency.usage)
    end

    drop_table :frequencies_stations
  end
end
