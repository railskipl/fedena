require 'test_helper'

class AdditionalExamGroupTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: additional_exam_groups
#
#  id               :integer(4)      not null, primary key
#  name             :string(255)
#  batch_id         :integer(4)
#  exam_type        :string(255)
#  is_published     :boolean(1)      default(FALSE)
#  result_published :boolean(1)      default(FALSE)
#  students_list    :string(255)
#  exam_date        :date
#

