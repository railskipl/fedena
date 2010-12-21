require 'spec_helper'

describe GroupedExam do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    GroupedExam.create!(@valid_attributes)
  end
end

# == Schema Information
#
# Table name: grouped_exams
#
#  id            :integer(4)      not null, primary key
#  exam_group_id :integer(4)
#  batch_id      :integer(4)
#

