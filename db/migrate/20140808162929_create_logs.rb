class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string :name
      t.text :remarks

      t.references :user

      t.integer :location_precision, :limit => 4, :default => 0

      t.decimal :lon, :precision => 10, :scale => 6
      t.decimal :lat, :precision => 10, :scale => 6

      t.string :street_address
      t.string :administrative_area_level_3
      t.string :administrative_area_level_2
      t.string :administrative_area_level_1
      t.string :country

      t.timestamps
    end

    add_index :logs, :user_id
  end
end
