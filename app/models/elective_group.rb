class ElectiveGroup < ActiveRecord::Base
  belongs_to :batch
  belongs_to :subject
  has_many :subject

  validates_presence_of :name

  named_scope :for_batch, lambda { |b| { :conditions => { :batch_id => b, :is_deleted => false } } }

  def inactivate
    update_attribute(:is_deleted, false)
  end
end

# == Schema Information
#
# Table name: elective_groups
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  batch_id   :integer(4)
#  is_deleted :boolean(1)      default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#

