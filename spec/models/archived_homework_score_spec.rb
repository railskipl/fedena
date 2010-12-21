require 'spec_helper'

describe ArchivedHomeworkScore do
  before(:each) do
    @valid_attributes = {
      :student_id => 1,
      :homework_id => 1,
      :marks => 9.99,
      :grading_level_id => 1,
      :remarks => "value for remarks",
      :is_failed => false,
      :created_at => Time.now,
      :updated_at => Time.now
    }
  end

  it "should create a new instance given valid attributes" do
    ArchivedHomeworkScore.create!(@valid_attributes)
  end
end

# == Schema Information
#
# Table name: archived_homework_scores
#
#  id               :integer(4)      not null, primary key
#  student_id       :integer(4)
#  homework_id      :integer(4)
#  marks            :integer(10)
#  grading_level_id :integer(4)
#  remarks          :string(255)
#  is_failed        :boolean(1)
#  created_at       :datetime
#  updated_at       :datetime
#

