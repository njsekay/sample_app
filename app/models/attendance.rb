class Attendance < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('month, day')}
end
