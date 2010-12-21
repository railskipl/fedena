class StudentPreviousSubjectMark < ActiveRecord::Base
  belongs_to :student
end

# == Schema Information
#
# Table name: student_previous_subject_marks
#
#  id         :integer(4)      not null, primary key
#  student_id :integer(4)
#  subject    :string(255)
#  mark       :string(255)
#

