require 'spec_helper'

describe Homework do
  before(:each) do
    @valid_attributes = {
      :homework_group_id => 1,
      :subject_id => 1,
      :start_time => Time.now,
      :end_time => Time.now,
      :maximum_marks => 1,
      :minimum_marks => 1,
      :grading_level_id => 1,
      :weightage => 1,
      :event_id => 1,
      :created_at => Time.now,
      :updated_at => Time.now
    }
  end

  it "should create a new instance given valid attributes" do
    Homework.create!(@valid_attributes)
  end
end



# == Schema Information
#
# Table name: homeworks
#
#  id                :integer(4)      not null, primary key
#  homework_group_id :integer(4)
#  subject_id        :integer(4)
#  start_time        :datetime
#  end_time          :datetime
#  maximum_marks     :integer(4)
#  minimum_marks     :integer(4)
#  grading_level_id  :integer(4)
#  weightage         :integer(4)
#  event_id          :integer(4)
#  created_at        :datetime
#  updated_at        :datetime
#  description       :string(500)
#  hw_filename       :string(255)
#  hw_content_type   :string(255)
#  hw_data           :binary
#

