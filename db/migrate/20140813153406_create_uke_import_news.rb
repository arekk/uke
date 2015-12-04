class CreateUkeImportNews < ActiveRecord::Migration
  def change
    create_table :uke_import_news do |t|
      t.references :uke_import, index: true
      t.references :uke_station, index: true

      t.timestamps
    end

    add_index :uke_import_news, [:uke_import_id, :uke_station_id]
  end
end
