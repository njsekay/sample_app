class ChangeColumnToAttendances < ActiveRecord::Migration
  def change
    add_column :attendances, :start_time, :string, :limit => 5, :null => false, :default => "00:00"
    add_column :attendances, :end_time, :string, :limit => 5, :null => false, :default => "00:00"
    change_column(:attendances, :tyouka_time, :float, :scale => 2, :default => 0.00)
    change_column(:attendances, :kyujitu_time, :float, :scale => 2, :default => 0.00)
    change_column(:attendances, :sinya_time, :float, :scale => 2, :default => 0.00)
    change_column(:attendances, :kyuukei_time, :float, :scale => 2, :default => 0.00)
    change_column(:attendances, :koujo_time, :float, :scale => 2, :default => 0.00)
    change_column(:attendances, :jitudou_time, :float, :scale => 2, :default => 0.00)
    add_column :attendances, :kyuujitu_kbn, :string, :limit => 1, :null => false, :default => "0"
    add_column :attendances, :kaigi_kbn, :string, :limit => 1, :null => false, :default => "1"
    add_column :attendances, :kinmu_kbn, :string, :limit => 1, :null => false, :default => "1"
  end
end
