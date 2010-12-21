class Attendance < ActiveRecord::Base
  belongs_to :subject
  has_and_belongs_to_many :students
  validates_uniqueness_of :student_id, :scope => [:period_table_entry_id]
end

# == Schema Information
#
# Table name: attendances
#
#  id                    :integer(4)      not null, primary key
#  student_id            :integer(4)
#  period_table_entry_id :integer(4)
#  forenoon              :boolean(1)      default(FALSE)
#  afternoon             :boolean(1)      default(FALSE)
#  reason                :string(255)
#

