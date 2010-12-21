class AdditionalExamGroup < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :students_list
  belongs_to :batch
  has_many :additional_exams

  accepts_nested_attributes_for :additional_exams

  attr_accessor :maximum_marks, :minimum_marks, :weightage

  def before_save
    self.exam_date = self.exam_date || Date.today
  end

  def students
     students_array=[]
     list=self.students_list.split(",")
      list.each do |id|
        student =  Student.find_by_id(id)
        students_array.push student unless student.nil?
      end
      return students_array
  end
  
end

# == Schema Information
#
# Table name: additional_exam_groups
#
#  id               :integer(4)      not null, primary key
#  name             :string(255)
#  batch_id         :integer(4)
#  exam_type        :string(255)
#  is_published     :boolean(1)      default(FALSE)
#  result_published :boolean(1)      default(FALSE)
#  students_list    :string(255)
#  exam_date        :date
#

