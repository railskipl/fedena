class EmployeeLeaveType < ActiveRecord::Base

  validates_presence_of :name, :code
  validates_uniqueness_of :name, :code
  validates_numericality_of :max_leave_count
end

# == Schema Information
#
# Table name: employee_leave_types
#
#  id              :integer(4)      not null, primary key
#  name            :string(255)
#  code            :string(255)
#  status          :boolean(1)
#  max_leave_count :string(255)
#

