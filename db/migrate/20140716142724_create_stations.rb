class CreateStations < ActiveRecord::Migration
  def change
    create_table :stations do |t|
      t.string :name
      t.string :purpose, :limit => 2
      t.string :net,  :limit => 1
      t.decimal :lon, :precision => 10, :scale => 6
      t.decimal :lat, :precision => 10, :scale => 6
      t.integer :radius
      t.string :location
      t.string :location_geocoded
      t.decimal :erp, :precision => 5, :scale => 1
      t.decimal :ant_efficiency, :precision => 5, :scale => 1
      t.integer :ant_height
      t.string  :ant_polarisation, :limit => 2
      t.boolean :directional

      t.references :operator, index: true
      t.references :permit, index: true

      t.timestamps
    end

    add_index :stations, [:lon, :lat]

    create_join_table :frequencies, :stations do |t|
      t.index :frequency_id
      t.index :station_id
    end
  end
end
