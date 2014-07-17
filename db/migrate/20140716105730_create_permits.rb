class CreatePermits < ActiveRecord::Migration
  def change
    create_table :permits do |t|
      t.string :number
      t.date :valid_to

      t.timestamps
    end

    add_index :permits, :valid_to
  end
end
