class DropUserData < ActiveRecord::Migration
  def change
    drop_table :logs
    drop_table :log_entries
    drop_table :users
  end
end
