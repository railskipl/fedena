require 'test_helper'

class AdditionalExamTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: additional_exams
#
#  id                       :integer(4)      not null, primary key
#  additional_exam_group_id :integer(4)
#  subject_id               :integer(4)
#  start_time               :datetime
#  end_time                 :datetime
#  maximum_marks            :integer(4)
#  minimum_marks            :integer(4)
#  grading_level_id         :integer(4)
#  weightage                :integer(4)      default(0)
#  event_id                 :integer(4)
#  created_at               :datetime
#  updated_at               :datetime
#

