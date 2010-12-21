class EmployeeCategory < ActiveRecord::Base
  validates_presence_of :name, :prefix
  validates_uniqueness_of :name, :prefix

  has_many :employee_positions
  belongs_to :employee_salary_structure
end

# == Schema Information
#
# Table name: employee_categories
#
#  id     :integer(4)      not null, primary key
#  name   :string(255)
#  prefix :string(255)
#  status :boolean(1)
#

