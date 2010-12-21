class FinanceTransactionCategory < ActiveRecord::Base
  has_many :finance_transactions
  has_one  :trigger, :class_name => "FinanceTransactionTrigger", :foreign_key => "category_id"


  validates_presence_of :name

  named_scope :expense_categories, :conditions => "is_income = false AND name NOT LIKE 'Salary'"
  named_scope :income_categories, :conditions => "is_income = true AND name NOT LIKE 'Fee' AND name NOT LIKE 'Donation'"

#  def self.expense_categories
#    FinanceTransactionCategory.all(:conditions => "is_income = false AND name NOT LIKE 'Salary'")
#  end
#
#  def self.income_categories
#    FinanceTransactionCategory.all(:conditions => "is_income = true AND name NOT LIKE 'Fee' AND name NOT LIKE 'Donation'")
#  end

end

# == Schema Information
#
# Table name: finance_transaction_categories
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  description :string(255)
#  is_income   :boolean(1)
#  deleted     :boolean(1)      default(FALSE), not null
#

