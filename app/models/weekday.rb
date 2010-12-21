class Weekday < ActiveRecord::Base
  belongs_to :batch

  default_scope :order => 'weekday asc'
  named_scope   :default, :conditions => { :batch_id => nil}
  named_scope   :for_batch, lambda { |b| { :conditions => { :batch_id => b.to_i } } }
end

# == Schema Information
#
# Table name: weekdays
#
#  id       :integer(4)      not null, primary key
#  batch_id :integer(4)
#  weekday  :string(255)
#

