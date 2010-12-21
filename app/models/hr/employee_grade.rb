class EmployeeGrade < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name, :priority
end

# == Schema Information
#
# Table name: employee_grades
#
#  id             :integer(4)      not null, primary key
#  name           :string(255)
#  priority       :integer(4)
#  status         :boolean(1)
#  max_hours_day  :integer(4)
#  max_hours_week :integer(4)
#

