require 'test_helper'

class StudentPreviousSubjectMarkTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
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

