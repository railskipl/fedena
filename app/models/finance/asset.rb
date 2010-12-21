class Asset < ActiveRecord::Base
  validates_numericality_of :amount
end

# == Schema Information
#
# Table name: assets
#
#  id          :integer(4)      not null, primary key
#  title       :string(255)
#  description :text
#  amount      :integer(4)
#  is_inactive :boolean(1)      default(FALSE)
#  is_deleted  :boolean(1)      default(FALSE)
#  created_at  :datetime
#  updated_at  :datetime
#

