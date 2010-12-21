class MonthlyPayslip < ActiveRecord::Base

  validates_presence_of :salary_date

  belongs_to :payroll_category
  belongs_to :approver ,:class_name => 'User'

  def approve(user_id)
    self.is_approved = true
    self.approver_id = user_id
    self.save
  end

  def payslip_count(start_date,end_date)
    
  end


end

# == Schema Information
#
# Table name: monthly_payslips
#
#  id                  :integer(4)      not null, primary key
#  salary_date         :date
#  employee_id         :integer(4)
#  payroll_category_id :integer(4)
#  amount              :string(255)
#  is_approved         :boolean(1)      default(FALSE), not null
#  approver_id         :integer(4)
#

