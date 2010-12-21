require 'spec_helper'

describe ExamScore do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    ExamScore.create!(@valid_attributes)
  end
end

# == Schema Information
#
# Table name: exam_scores
#
#  id               :integer(4)      not null, primary key
#  student_id       :integer(4)
#  exam_id          :integer(4)
#  marks            :decimal(7, 2)
#  grading_level_id :integer(4)
#  remarks          :string(255)
#  is_failed        :boolean(1)
#  created_at       :datetime
#  updated_at       :datetime
#

