class ApplyLeave < ActiveRecord::Base
  validates_presence_of :employee_leave_types_id, :start_date, :end_date, :reason
  belongs_to :employee
  
  cattr_reader :per_page
  @@per_page = 12
  
end

# == Schema Information
#
# Table name: apply_leaves
#
#  id                      :integer(4)      not null, primary key
#  employee_id             :integer(4)
#  employee_leave_types_id :integer(4)
#  is_half_day             :boolean(1)
#  start_date              :date
#  end_date                :date
#  reason                  :string(255)
#  approved                :boolean(1)      default(FALSE)
#  viewed_by_manager       :boolean(1)      default(FALSE)
#  manager_remark          :string(255)
#

