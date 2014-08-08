class CreateFrequencyAssignments < ActiveRecord::Migration
  def change
    create_table :frequency_assignments do |t|
      t.references :subject, polymorphic: true
      t.references :frequency
      t.string  :usage, :limit => 2

      t.timestamps
    end

    add_index :frequency_assignments, [:subject_type, :subject_id]
    add_index :frequency_assignments, :frequency_id
    add_index :frequency_assignments, [:subject_type, :subject_id, :usage], name: 'assigned_frequencies_on_subject_usage'
  end
end
