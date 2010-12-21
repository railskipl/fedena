require 'spec_helper'

describe GroupedHomework do
  before(:each) do
    @valid_attributes = {
      :homework_group_id => 1,
      :batch_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    GroupedHomework.create!(@valid_attributes)
  end
end

# == Schema Information
#
# Table name: grouped_homeworks
#
#  id                :integer(4)      not null, primary key
#  homework_group_id :integer(4)
#  batch_id          :integer(4)
#  created_at        :datetime
#  updated_at        :datetime
#

