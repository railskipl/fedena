class EmployeePosition < ActiveRecord::Base
  validates_presence_of :name, :employee_category_id
  validates_uniqueness_of :name

  belongs_to :employee_category
end

# == Schema Information
#
# Table name: employee_positions
#
#  id                   :integer(4)      not null, primary key
#  name                 :string(255)
#  employee_category_id :integer(4)
#  status               :boolean(1)
#

