class CreateFrequencies < ActiveRecord::Migration
  def change
    create_table :frequencies do |t|
      t.string  :usage, :limit => 2
      t.decimal :mhz,   :precision => 10, :scale => 4
      t.decimal :step,  :precision => 5, :scale => 2

      t.timestamps
    end

    add_index :frequencies, :mhz
  end
end
