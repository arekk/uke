class AlterLogEntriesAddLocation < ActiveRecord::Migration
  def change
    add_column :log_entries, :lon, :decimal, :precision => 10, :scale => 6
    add_column :log_entries, :lat, :decimal, :precision => 10, :scale => 6
    add_column :log_entries, :street_address, :string
    add_column :log_entries, :administrative_area_level_3, :string
    add_column :log_entries, :administrative_area_level_2, :string
    add_column :log_entries, :administrative_area_level_1, :string
    add_column :log_entries, :country, :string
  end
end
