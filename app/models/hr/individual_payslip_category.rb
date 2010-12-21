class IndividualPayslipCategory < ActiveRecord::Base
end

# == Schema Information
#
# Table name: individual_payslip_categories
#
#  id                  :integer(4)      not null, primary key
#  employee_id         :integer(4)
#  salary_date         :date
#  name                :string(255)
#  amount              :string(255)
#  is_deduction        :boolean(1)
#  include_every_month :boolean(1)
#

