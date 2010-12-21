class PayrollCategory < ActiveRecord::Base
  validates_uniqueness_of :name
  validates_presence_of   :name

  has_many :monthly_paslips

end

# == Schema Information
#
# Table name: payroll_categories
#
#  id                  :integer(4)      not null, primary key
#  name                :string(255)
#  percentage          :float
#  payroll_category_id :integer(4)
#  is_deduction        :boolean(1)
#  status              :boolean(1)
#

