class StudentAdditionalDetails < ActiveRecord::Base
  belongs_to :student
  belongs_to :student_additional_field
end

# == Schema Information
#
# Table name: student_additional_details
#
#  id                  :integer(4)      not null, primary key
#  student_id          :integer(4)
#  additional_field_id :integer(4)
#  additional_info     :string(255)
#

