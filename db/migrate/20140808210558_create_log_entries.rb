class CreateLogEntries < ActiveRecord::Migration
  def change
    create_table :log_entries do |t|
      t.references :user
      t.references :log
      t.references :frequency_assignment

      t.text :description
      t.integer :level

      t.timestamps
    end

    add_index :log_entries, :log_id
    add_index :log_entries, :frequency_assignment_id
    add_index :log_entries, :user_id
  end
end
