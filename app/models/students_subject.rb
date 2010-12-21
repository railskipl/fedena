class StudentsSubject < ActiveRecord::Base
  belongs_to :student
  belongs_to :subject

  def student_assigned(student,subject)
    StudentsSubject.find_by_student_id_and_subject_id(student,subject)
  end
end

# == Schema Information
#
# Table name: students_subjects
#
#  id         :integer(4)      not null, primary key
#  student_id :integer(4)
#  subject_id :integer(4)
#  batch_id   :integer(4)
#

