require 'spec_helper'

describe HomeworkGroup do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :batch_id => 1,
      :homework_type => "value for homework_type",
      :is_published => false,
      :result_published => false,
      :homework_date => Date.today
    }
  end

  it "should create a new instance given valid attributes" do
    HomeworkGroup.create!(@valid_attributes)
  end
end



# == Schema Information
#
# Table name: homework_groups
#
#  id               :integer(4)      not null, primary key
#  name             :string(500)
#  batch_id         :integer(4)
#  homework_type    :string(255)
#  is_published     :boolean(1)
#  result_published :boolean(1)
#  homework_date    :date
#  created_at       :datetime
#  updated_at       :datetime
#

