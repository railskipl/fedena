class FinanceFeeParticulars < ActiveRecord::Base

  belongs_to :fee_category ,:class_name => "FinanceFeeCategory"
  belongs_to :student_category
  validates_presence_of :name,:amount
  validates_numericality_of :amount
  cattr_reader :per_page
  @@per_page = 10
  
  

end

# == Schema Information
#
# Table name: finance_fee_particulars
#
#  id                      :integer(4)      not null, primary key
#  name                    :string(255)
#  description             :text
#  amount                  :decimal(8, 2)
#  finance_fee_category_id :integer(4)
#  student_category_id     :integer(4)
#  admission_no            :string(255)
#  student_id              :integer(4)
#  is_deleted              :boolean(1)      default(FALSE), not null
#  created_at              :datetime
#  updated_at              :datetime
#

