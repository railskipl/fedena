class EmployeeAttendance < ActiveRecord::Base
  validates_presence_of :employee_leave_type_id
  validates_uniqueness_of :employee_id, :scope=> :attendance_date
  
end

# == Schema Information
#
# Table name: employee_attendances
#
#  id                     :integer(4)      not null, primary key
#  attendance_date        :date
#  employee_id            :integer(4)
#  employee_leave_type_id :integer(4)
#  reason                 :string(255)
#  is_half_day            :boolean(1)
#

