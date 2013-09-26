class AddIndexToAttendances < ActiveRecord::Migration
  def change
    add_index :attendances, [:user_id, :year, :month]
  end
end
