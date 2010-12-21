class NewsComment < ActiveRecord::Base
  belongs_to :news
  belongs_to :author, :class_name => 'User'

  validates_presence_of :content
  validates_presence_of :author
  validates_presence_of :news_id
end

# == Schema Information
#
# Table name: news_comments
#
#  id         :integer(4)      not null, primary key
#  content    :text
#  news_id    :integer(4)
#  author_id  :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

