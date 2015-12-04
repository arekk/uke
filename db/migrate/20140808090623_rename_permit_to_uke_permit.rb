class RenamePermitToUkePermit < ActiveRecord::Migration
  def change
    remove_index :permits, name: :index_permits_on_valid_to
    rename_table :permits, :uke_permits

    add_index :uke_permits, :valid_to
  end
end
