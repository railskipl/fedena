class StudentAdditionalField < ActiveRecord::Base
  belongs_to :student
  belongs_to :student_additional_details
  validates_presence_of :name
  validates_uniqueness_of :name,:case_sensitive => false
end

# == Schema Information
#
# Table name: student_additional_fields
#
#  id     :integer(4)      not null, primary key
#  name   :string(255)
#  status :boolean(1)
#

