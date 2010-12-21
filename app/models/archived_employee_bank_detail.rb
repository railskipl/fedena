class ArchivedEmployeeBankDetail < ActiveRecord::Base
  belongs_to :archived_employee
  belongs_to :bank_field
end

# == Schema Information
#
# Table name: archived_employee_bank_details
#
#  id            :integer(4)      not null, primary key
#  employee_id   :integer(4)
#  bank_field_id :integer(4)
#  bank_info     :string(255)
#

