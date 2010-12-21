class FinanceFee < ActiveRecord::Base

  belongs_to :finance_fee_collection
  belongs_to :transaction, :class_name => 'FinanceTransaction'
  has_many :components, :class_name => 'FinanceFeeComponent', :foreign_key => 'fee_id'
  belongs_to :student


  def check_transaction_done
    unless self.transaction_id.nil?
      return true
    else
      return false
    end
  end
end

# == Schema Information
#
# Table name: finance_fees
#
#  id                :integer(4)      not null, primary key
#  fee_collection_id :integer(4)
#  transaction_id    :integer(4)
#  student_id        :integer(4)
#

