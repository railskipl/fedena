class GradingLevel < ActiveRecord::Base
  belongs_to :batch

  validates_presence_of :name, :min_score
  validates_uniqueness_of :name, :scope => [:batch_id, :is_deleted],:case_sensitive => false 

  default_scope :order => 'min_score desc'
  named_scope   :default, :conditions => { :batch_id => nil, :is_deleted => false }
  named_scope   :for_batch, lambda { |b| { :conditions => { :batch_id => b.to_i, :is_deleted => false } } }

  def inactivate
    update_attribute :is_deleted, true
  end

  def to_s
    name
  end

  class << self
    def percentage_to_grade(percent_score, batch_id)
      batch_grades = GradingLevel.for_batch(batch_id)
      if batch_grades.empty?
        grade = GradingLevel.default.find :first,
          :conditions => [ "min_score <= ?", percent_score.round ], :order => 'min_score desc'
      else
        grade = GradingLevel.for_batch(batch_id).find :first,
          :conditions => [ "min_score <= ?", percent_score.round ], :order => 'min_score desc'
      end
      grade
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

