require File.expand_path(File.dirname(__FILE__) + './../test_helper')

class SubjectTest < ActiveSupport::TestCase

  context 'a new subject' do
    
  end

end

# == Schema Information
#
# Table name: subjects
#
#  id                 :integer(4)      not null, primary key
#  name               :string(255)
#  code               :string(255)
#  batch_id           :integer(4)
#  no_exams           :boolean(1)      default(FALSE)
#  max_weekly_classes :integer(4)
#  elective_group_id  :integer(4)
#  is_deleted         :boolean(1)      default(FALSE)
#  created_at         :datetime
#  updated_at         :datetime
#  no_homeworks       :boolean(1)
#

