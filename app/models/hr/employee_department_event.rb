class EmployeeDepartmentEvent < ActiveRecord::Base
end

# == Schema Information
#
# Table name: employee_department_events
#
#  id                     :integer(4)      not null, primary key
#  event_id               :integer(4)
#  employee_department_id :integer(4)
#  created_at             :datetime
#  updated_at             :datetime
#

