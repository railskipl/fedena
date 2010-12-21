require File.expand_path(File.dirname(__FILE__) + './../test_helper')

class GradingLevelTest < ActiveSupport::TestCase
  fixtures :batches
  should_belong_to :batch
  
  context 'a new grading level' do
    setup do
      @grading_level = GradingLevel.new(:name => 'A', :min_score => 85, :order => 1)
    end

    should 'save with all valid data' do
      assert @grading_level.save
    end

    should 'not save withour name' do
      @grading_level.name = nil
      assert ! @grading_level.save
    end
  end

  context 'with an existing grading level' do
    setup do
      @grade = GradingLevel.create(
        :name => 'A',
        :batch_id => 1,
        :min_score => 80,
        :order => 1)
      @new_grade = GradingLevel.create(
        :name => 'A',
        :batch_id => 1,
        :min_score => 80,
        :order => 1)
    end

    should 'not save another grading level with same name within the batch' do
      assert ! @new_grade.save
    end

    should 'save another grading level with different name within the batch' do
      @new_grade.name = 'A+'
      assert @new_grade.save
    end
  end
end
# == Schema Information
#
# Table name: grading_levels
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  batch_id   :integer(4)
#  min_score  :integer(4)
#  order      :integer(4)
#  is_deleted :boolean(1)      default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#

