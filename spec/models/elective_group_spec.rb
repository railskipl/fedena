require 'spec_helper'

describe ElectiveGroup do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    ElectiveGroup.create!(@valid_attributes)
  end
end

# == Schema Information
#
# Table name: elective_groups
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  batch_id   :integer(4)
#  is_deleted :boolean(1)      default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#

