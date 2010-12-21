require 'spec_helper'

describe HomeworkScore do
  before(:each) do
    @valid_attributes = {
      :student_id => 1,
      :homework_id => 1,
      :marks => 9.99,
      :grading_level_id => 1,
      :remarks => "value for remarks",
      :is_failed => false,
      :created_at => ,
      :updated_at => 
    }
  end

  it "should create a new instance given valid attributes" do
    HomeworkScore.create!(@valid_attributes)
  end
end

# == Schema Information
#
# Table name: homework_scores
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

