class ClassTiming < ActiveRecord::Base
  has_many :timetable_entries
  belongs_to :batch

  validates_presence_of :name
  
  named_scope :for_batch, lambda { |b| { :conditions => { :batch_id => b.to_i } } }
  named_scope :default, :conditions => { :batch_id => nil, :is_break => false }

  def validate
    errors.add(:end_time, "should be later than start time.") \
      if self.start_time > self.end_time \
      unless self.start_time.nil? or self.end_time.nil?
  end
end

# == Schema Information
#
# Table name: class_timings
#
#  id         :integer(4)      not null, primary key
#  batch_id   :integer(4)
#  name       :string(255)
#  start_time :time
#  end_time   :time
#  is_break   :boolean(1)
#

