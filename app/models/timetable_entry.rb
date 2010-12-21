class TimetableEntry < ActiveRecord::Base
  belongs_to :course
  belongs_to :class_timing
  belongs_to :subject
  belongs_to :employee
end
# == Schema Information
#
# Table name: timetable_entries
#
#  id              :integer(4)      not null, primary key
#  batch_id        :integer(4)
#  week_day_id     :integer(4)
#  class_timing_id :integer(4)
#  subject_id      :integer(4)
#  employee_id     :integer(4)
#

