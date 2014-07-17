class CreateOperators < ActiveRecord::Migration
  def change
    create_table :operators do |t|
      t.string :name
      t.string :address
      t.string :name_unified

      t.timestamps
    end

    add_index :operators, :name_unified
  end
end
