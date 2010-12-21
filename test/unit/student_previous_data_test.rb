require 'test_helper'

class StudentPreviousDataTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: student_previous_datas
#
#  id          :integer(4)      not null, primary key
#  student_id  :integer(4)
#  institution :string(255)
#  year        :string(255)
#  course      :string(255)
#  total_mark  :string(255)
#

