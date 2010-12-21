class ArchivedEmployeeAdditionalDetail < ActiveRecord::Base
  belongs_to :archived_employee
  belongs_to :additional_field
end

# == Schema Information
#
# Table name: archived_employee_additional_details
#
#  id                  :integer(4)      not null, primary key
#  employee_id         :integer(4)
#  additional_field_id :integer(4)
#  additional_info     :string(255)
#

