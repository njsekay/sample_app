class AddWdayToAttendances < ActiveRecord::Migration
  def change
    add_column :attendances, :wday, :string, :limit => 1
  end
end
