class RenameStationToUkeStation < ActiveRecord::Migration
  def change
    remove_index :stations, name: :index_stations_on_operator_id
    remove_index :stations, name: :index_stations_on_permit_id
    remove_index :stations, name: :index_stations_on_lon_and_lat

    rename_table :stations, :uke_stations

    add_index :uke_stations, :operator_id
    add_index :uke_stations, :permit_id
    add_index :uke_stations, [:lon, :lat]

    add_column :uke_stations, :name_unified, :string, :null => false, :default => nil
    add_index :uke_stations, :name_unified
    
    UkeStation.all.each do |station|
      station.update_columns name_unified: Uke::Unifier::indexify_string(station.name + station.location)
    end
  end
end
