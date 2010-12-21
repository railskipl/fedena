require 'test_helper'

class AdditionalExamScoreTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: additional_exam_scores
#
#  id                 :integer(4)      not null, primary key
#  student_id         :integer(4)
#  additional_exam_id :integer(4)
#  marks              :decimal(7, 2)
#  grading_level_id   :integer(4)
#  remarks            :string(255)
#  is_failed          :boolean(1)
#  created_at         :datetime
#  updated_at         :datetime
#

