class HomeworkGroup < ActiveRecord::Base
    validates_presence_of :name

    belongs_to :batch
    belongs_to :grouped_homework

    has_many :homeworks

    accepts_nested_attributes_for :homeworks

    attr_accessor :maximum_marks, :minimum_marks, :weightage

    def before_save
      self.homework_date = self.homework_date || Date.today
    end

    def batch_average_marks(marks)
      batch = self.batch
      homeworks = self.homeworks
      batch_students = batch.students
      total_students_marks = 0
   #   total_max_marks = 0
      students_attended = []
      homeworks.each do |homework|
        batch_students.each do |student|
          homework_score = HomeworkScore.find_by_student_id_and_homework_id(student.id,homework.id)
          unless homework_score.nil?
            total_students_marks = total_students_marks+homework_score.marks
            unless students_attended.include? student.id
              students_attended.push student.id
            end
          end
        end
        #      total_max_marks = total_max_marks+homework.maximum_marks
      end
      unless students_attended.size == 0
        batch_average_marks = total_students_marks/students_attended.size
      else
        batch_average_marks = 0
      end
      return batch_average_marks if marks == 'marks'
      #   return total_max_marks if marks == 'percentage'
    end

    def batch_average_percentage

    end

    def subject_wise_batch_average_marks(subject_id)
      batch = self.batch
      subject = Subject.find(subject_id)
      homework = Homework.find_by_homework_group_id_and_subject_id(self.id,subject.id)
      batch_students = batch.students
      total_students_marks = 0
      #   total_max_marks = 0
      students_attended = []

      batch_students.each do |student|
        homework_score = HomeworkScore.find_by_student_id_and_homework_id(student.id,homework.id)
        unless homework_score.nil?
          total_students_marks = total_students_marks+homework_score.marks
          unless students_attended.include? student.id
            students_attended.push student.id
          end
        end
      end
      #      total_max_marks = total_max_marks+homework.maximum_marks
      unless students_attended.size == 0
        subject_wise_batch_average_marks = total_students_marks/students_attended.size.to_f
      else
        subject_wise_batch_average_marks = 0
      end
      return subject_wise_batch_average_marks
      #   return total_max_marks if marks == 'percentage'
    end

    def total_marks(student)
      homeworks = Homework.find_all_by_homework_group_id(self.id)
      total_marks = 0
      max_total = 0
      homeworks.each do |homework|
        homework_score = HomeworkScore.find_by_homework_id_and_student_id(homework.id,student.id)
        total_marks = total_marks + homework_score.marks unless homework_score.nil?
        max_total = max_total + homework.maximum_marks unless homework_score.nil?
      end
      result = [total_marks,max_total]
    end

      def archived_total_marks(student)
      homeworks = Homework.find_all_by_homework_group_id(self.id)
      total_marks = 0
      max_total = 0
      homeworks.each do |homework|
        homework_score = ArchivedhomeworkScore.find_by_homework_id_and_student_id(homework.id,student.id)
        total_marks = total_marks + homework_score.marks unless homework_score.nil?
        max_total = max_total + homework.maximum_marks unless homework_score.nil?
      end
      result = [total_marks,max_total]
    end

  end



# == Schema Information
#
# Table name: homework_groups
#
#  id               :integer(4)      not null, primary key
#  name             :string(500)
#  batch_id         :integer(4)
#  homework_type    :string(255)
#  is_published     :boolean(1)
#  result_published :boolean(1)
#  homework_date    :date
#  created_at       :datetime
#  updated_at       :datetime
#

