class Subject < ActiveRecord::Base

  belongs_to :batch
  belongs_to :elective_group

  validates_presence_of :name, :max_weekly_classes, :code
  validates_numericality_of :max_weekly_classes

  named_scope :for_batch, lambda { |b| { :conditions => { :batch_id => b.to_i, :is_deleted => false } } }
  named_scope :without_exams, :conditions => { :no_exams => false, :is_deleted => false }
  
  named_scope :for_batch, lambda { |b| { :conditions => { :batch_id => b.to_i, :is_deleted => false } } }
  named_scope :without_homeworks, :conditions => { :no_homeworks => false, :is_deleted => false }

  def inactivate
    update_attribute(:is_deleted, true)
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

