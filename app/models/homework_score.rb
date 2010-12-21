class HomeworkScore < ActiveRecord::Base
    belongs_to :student
    belongs_to :homework
    belongs_to :grading_level

    before_save :calculate_grade

    def calculate_percentage
      percentage = self.marks.to_i * 100 / self.homework.maximum_marks
    end

    def grouped_homework_subject_total(subject,student,type,batch = "")
      if batch == ""
        batch = student.batch.id
      end
      if type == 'grouped'
        grouped_homeworks = Groupedhomework.find_all_by_batch_id(batch)
        homework_groups = []
        grouped_homeworks.each do |x|
          eg = HomeworkGroup.find(x.homework_group_id)
          homework_groups.push HomeworkGroup.find(x.homework_group_id)
        end
      else
        homework_groups = HomeworkGroup.find_all_by_batch_id(batch)
      end
      total_marks = 0
      homework_groups.each do |homework_group|
        unless homework_group.homework_type == 'Grades'
          homework = homework.find_by_subject_id_and_homework_group_id(subject.id,homework_group.id)
          unless homework.nil?
            homework_score = HomeworkScore.find_by_student_id(student.id, :conditions=>{:homework_id=>homework.id})
            total_marks = total_marks+homework_score.marks unless homework_score.nil?
          end
        end
      end
      total_marks
    end



    def batch_wise_aggregate(student,batch)
      check =HhomeworkGroup.find_all_by_batch_id(batch.id)
      var = []
      check.each do |x|
        if x.homework_type == 'Grades'
          var << 1
        end
      end
      if var.empty?
        grouped_homework = Groupedhomework.find_all_by_batch_id(batch.id)
        if grouped_homework.empty?
          homework_groups = HomeworkGroup.find_all_by_batch_id(batch.id)
        else
          homework_groups = []
          grouped_homework.each do |x|
            homework_groups.push HomeworkGroup.find(x.homework_group_id)
          end
        end
        homework_groups.size
        max_total = 0
        marks_total = 0
        homework_groups.each do |homework_group|
          max_total = max_total + homework_group.total_marks(student)[1]
          marks_total = marks_total + homework_group.total_marks(student)[0]
        end
        aggr = (marks_total*100/max_total) unless max_total==0
      else
        aggr = 'nil'
      end

    end

    private
    def calculate_grade
      homework = self.homework
      homework_group = homework.homework_group
      homework_type = homework_group.homework_type
      unless homework_type == 'Grades'
        unless self.marks.nil?
          percent_score = self.marks.to_i * 100 / self.homework.maximum_marks
          grade = GradingLevel.percentage_to_grade(percent_score, self.student.batch_id)
          self.grading_level_id = grade.id if homework_type == 'MarksAndGrades'
        else
          self.grading_level_id = nil
        end
      end
    end

  end

# == Schema Information
#
# Table name: homework_scores
#
#  id               :integer(4)      not null, primary key
#  student_id       :integer(4)
#  homework_id      :integer(4)
#  marks            :integer(10)
#  grading_level_id :integer(4)
#  remarks          :string(255)
#  is_failed        :boolean(1)
#  created_at       :datetime
#  updated_at       :datetime
#

