class FinanceTransactionTrigger < ActiveRecord::Base
  belongs_to :finance_category, :class_name => "FinanceTransactionCategory", :foreign_key => 'finance_category_id'
  validates_numericality_of :percentage
end

# == Schema Information
#
# Table name: finance_transaction_triggers
#
#  id                  :integer(4)      not null, primary key
#  finance_category_id :integer(4)
#  percentage          :decimal(8, 2)
#  title               :string(255)
#  description         :string(255)
#

