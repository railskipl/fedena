require 'test_helper'

class ArchivedEmployeeSalaryStructureTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: archived_employee_salary_structures
#
#  id                  :integer(4)      not null, primary key
#  employee_id         :integer(4)
#  payroll_category_id :integer(4)
#  amount              :string(255)
#

