class RenameOperatorToUkeOperator < ActiveRecord::Migration
  def change
    remove_index :operators, name: :index_operators_on_name_unified
    rename_table :operators, :uke_operators

    add_index :uke_operators, :name_unified
  end
end
