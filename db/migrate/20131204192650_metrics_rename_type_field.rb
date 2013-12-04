class MetricsRenameTypeField < ActiveRecord::Migration
  def up
  	rename_column :metrics, :type, :metric_type
  end

  def down
  	rename_column :metrics, :metric_type, :type
  end
end
