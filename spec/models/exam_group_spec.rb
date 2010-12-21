require 'spec_helper'

describe ExamGroup do
  before(:each) do
    @valid_attributes = Factory.attributes_for :exam_group
  end

  it "should create a new instance given valid attributes" do
    ExamGroup.create!(@valid_attributes)
  end
end

# == Schema Information
#
# Table name: exam_groups
#
#  id               :integer(4)      not null, primary key
#  name             :string(255)
#  batch_id         :integer(4)
#  exam_type        :string(255)
#  is_published     :boolean(1)      default(FALSE)
#  result_published :boolean(1)      default(FALSE)
#  exam_date        :date
#

