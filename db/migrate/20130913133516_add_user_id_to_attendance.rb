class AddUserIdToAttendance < ActiveRecord::Migration
  def change
    add_column :attendances, :user_id, :integer
  end
end
