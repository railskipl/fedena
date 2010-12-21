require 'test_helper'

class ArchivedEmployeeBankDetailTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
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

