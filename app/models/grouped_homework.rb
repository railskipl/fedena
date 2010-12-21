class GroupedHomework < ActiveRecord::Base
  has_many :homework_groups
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

