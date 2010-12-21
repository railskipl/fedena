class BatchEvent < ActiveRecord::Base
end

# == Schema Information
#
# Table name: batch_events
#
#  id         :integer(4)      not null, primary key
#  event_id   :integer(4)
#  batch_id   :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

