class PeriodEntry < ActiveRecord::Base
  belongs_to :batch
  belongs_to :class_timing
  belongs_to :subject
  belongs_to :employee
end

# == Schema Information
#
# Table name: period_entries
#
#  id              :integer(4)      not null, primary key
#  month_date      :date
#  batch_id        :integer(4)
#  subject_id      :integer(4)
#  class_timing_id :integer(4)
#  employee_id     :integer(4)
#

