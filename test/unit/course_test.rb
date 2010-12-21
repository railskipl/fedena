require File.expand_path(File.dirname(__FILE__) + './../test_helper')

class CourseTest < ActiveSupport::TestCase

  should_validate_presence_of :course_name
  should_have_many :batches

#  context 'a new course' do
#    setup do
#      @course = Factory.build(:course)
#      @batch = Factory.build(:batch)
#      @course.batches << @batch
#    end
#  end

end
# == Schema Information
#
# Table name: courses
#
#  id           :integer(4)      not null, primary key
#  course_name  :string(255)
#  code         :string(255)
#  section_name :string(255)
#  is_deleted   :boolean(1)      default(FALSE)
#  created_at   :datetime
#  updated_at   :datetime
#

