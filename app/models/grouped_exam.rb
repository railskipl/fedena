class GroupedExam < ActiveRecord::Base
  has_many :exam_groups
end

# == Schema Information
#
# Table name: grouped_exams
#
#  id            :integer(4)      not null, primary key
#  exam_group_id :integer(4)
#  batch_id      :integer(4)
#

