class AlterUkeStationChangeOperatorPermit < ActiveRecord::Migration
  def change
    remove_index :uke_stations, name: :index_uke_stations_on_operator_id
    remove_index :uke_stations, name: :index_uke_stations_on_permit_id

    rename_column :uke_stations, :operator_id, :uke_operator_id
    rename_column :uke_stations, :permit_id, :uke_permit_id

    add_index :uke_stations, :uke_operator_id
    add_index :uke_stations, :uke_permit_id
  end
end
