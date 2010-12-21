class EmployeesSubject < ActiveRecord::Base
  belongs_to :employee
  belongs_to :subject
end

# == Schema Information
#
# Table name: employees_subjects
#
#  id          :integer(4)      not null, primary key
#  employee_id :integer(4)
#  subject_id  :integer(4)
#

