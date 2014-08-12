class CreateBandplans < ActiveRecord::Migration
  def change
    create_table :bandplans do |t|
      t.decimal :mhz_start, :precision => 10, :scale => 4, null: false
      t.decimal :mhz_end, :precision => 10, :scale => 4, null: false
      t.decimal :step, :precision => 5, :scale => 2
      t.string :purpose
      t.text :description

      t.timestamps
    end

    add_index :bandplans, [:mhz_start, :mhz_end]
  end
end
