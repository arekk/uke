class CreateUkeImports < ActiveRecord::Migration
  def change
    create_table :uke_imports do |t|
      t.date :released_on
      t.boolean :active, default: false
      t.timestamps
    end

    add_index :uke_imports, :active

    UkeImport.create(:id => 1, :released_on => Date.parse('2014-07-10'), :active => true)

    add_column :uke_stations, :uke_import_id, :integer, default: 1
    add_index :uke_stations,  :uke_import_id

    add_column :frequency_assignments, :uke_import_id, :integer, default: nil
    add_index :frequency_assignments,  :uke_import_id

    execute "UPDATE frequency_assignments SET uke_import_id = 1 WHERE subject_type='UkeStation'"
  end
end
