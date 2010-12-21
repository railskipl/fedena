require 'test_helper'

class ElectiveGroupTest < ActiveSupport::TestCase
  should_belong_to :batch
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

