class Reminder < ActiveRecord::Base
  validates_presence_of :body

  cattr_reader :per_page
  @@per_page = 12
end

# == Schema Information
#
# Table name: reminders
#
#  id                      :integer(4)      not null, primary key
#  sender                  :integer(4)
#  recipient               :integer(4)
#  subject                 :string(255)
#  body                    :text
#  is_read                 :boolean(1)      default(FALSE)
#  is_deleted_by_sender    :boolean(1)      default(FALSE)
#  is_deleted_by_recipient :boolean(1)      default(FALSE)
#  created_at              :datetime
#  updated_at              :datetime
#

