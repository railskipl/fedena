class Event < ActiveRecord::Base
  validates_presence_of :title, :description

  named_scope :holidays, :conditions => {:is_holiday => true}
  named_scope :exams, :conditions => {:is_exam => true}
  named_scope :homework, :conditions => {:is_homework => true}

  class << self
    def is_a_holiday?(day)
      return true if Event.holidays.count(:all, :conditions => ["start_date <=? AND end_date >= ?", day, day] ) > 0
      false
    end
  end

  
end


# == Schema Information
#
# Table name: events
#
#  id          :integer(4)      not null, primary key
#  title       :string(255)
#  description :string(255)
#  start_date  :datetime
#  end_date    :datetime
#  is_common   :boolean(1)      default(FALSE)
#  is_holiday  :boolean(1)      default(FALSE)
#  is_exam     :boolean(1)      default(FALSE)
#  is_due      :boolean(1)      default(FALSE)
#  created_at  :datetime
#  updated_at  :datetime
#  is_homework :boolean(1)
#

