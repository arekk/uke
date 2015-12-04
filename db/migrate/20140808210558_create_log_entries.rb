class CreateLogEntries < ActiveRecord::Migration
  def change
    create_table :log_entries do |t|
      t.references :user
      t.references :log

      t.text :description
      t.integer :level
      t.string :net, :limit => 1
      t.integer :related_frequency_assignment_id

      t.timestamps
    end

    add_index :log_entries, :log_id
    add_index :log_entries, :user_id

    add_index :log_entries, :related_frequency_assignment_id

  end
end
