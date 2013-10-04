class ChangeSyuttyouToAttendances < ActiveRecord::Migration
  def change
    rename_column :attendances, :hankyuu, :syuttyou
  end
end
