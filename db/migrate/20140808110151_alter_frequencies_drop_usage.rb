class AlterFrequenciesDropUsage < ActiveRecord::Migration
  def change
    remove_column :frequencies, :usage
  end
end
