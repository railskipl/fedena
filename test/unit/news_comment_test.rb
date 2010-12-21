require File.expand_path(File.dirname(__FILE__) + './../test_helper')

class NewsCommentTest < ActiveSupport::TestCase
  should_validate_presence_of :author
  should_validate_presence_of :content
  should_validate_presence_of :news_id
  
  should_belong_to :news
  should_belong_to :author
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

