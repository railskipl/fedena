pdf.header pdf.margin_box.top_left do
  if FileTest.exists?("#{RAILS_ROOT}/public/uploads/image/institute_logo.jpg")
    logo = "#{RAILS_ROOT}/public/uploads/image/institute_logo.jpg"
  else
    logo = "#{RAILS_ROOT}/public/images/application/app_fedena_logo.jpg"
  end
  @institute_name=Configuration.get_config_value('InstitutionName');
  @institute_address=Configuration.get_config_value('InstitutionAddress');
  pdf.image logo, :position=>:left, :height=>50, :width=>50
  pdf.font "Helvetica" do
    info = [[@institute_name],
      [@institute_address]]
    pdf.move_up(50)
    pdf.fill_color "97080e"
    pdf.table info, :width => 400,
      :align => {0 => :center},
      :position => :center,
      :border_color => "FFFFFF"
    pdf.move_down(20)
    pdf.stroke_horizontal_rule
  end
end




@all_batches.each do |b|
  @type = params[:type]
  if @type == 'grouped'
		@grouped_homeworks = Groupedhomework.find_all_by_batch_id(b.id)
		@homework_groups = []
		@grouped_homeworks.each do |x|
		  @homework_groups.push homeworkGroup.find(x.homework_group_id)
		end
	  else
		@homework_groups = homeworkGroup.find_all_by_batch_id(b.id)
  end
  general_subjects = Subject.find_all_by_batch_id(b.id, :conditions=>"elective_group_id IS NULL AND is_deleted=false")
  student_electives = StudentsSubject.find_all_by_student_id(@student.id,:conditions=>"batch_id = #{b.id}")
  elective_subjects = []
  student_electives.each do |elect|
    elective_subjects.push Subject.find(elect.subject_id)
  end
  @subjects = general_subjects + elective_subjects

  homework = homeworkScore.new()
  @aggr =  homework.batch_wise_aggregate(@student,b)
    data =Array.new(){Array.new()}
  table_header = Array.new()
  table_header<<"Subject"
  @homework_groups.each do |homework_group|
    table_header<<homework_group.name
  end
  table_header<<"Total"

col_widths = Hash.new()
col_widths[0]=200

  @subjects.each do |subject|
    table_row=Array.new()
	table_row<<subject.name
           sub_total="-"
    @mmg = 1;@g = 1

    @homework_groups.each_with_index do |homework_group,i|
       col_widths[i+1]=(250/@homework_groups.size)
    @homework = homework.find_by_subject_id_and_homework_group_id(subject.id,homework_group.id)
    homework_score = homeworkScore.find_by_student_id(@student.id, :conditions=>{:homework_id=>@homework.id})unless @homework.nil?
	unless homework_score.nil?
		if homework_group.homework_type == "MarksAndGrades"
			unless @homework.nil?
				table_row<<"#{homework_score.marks }|#{@homework.maximum_marks}|#{homework_score.grading_level.name}"
                         else
                         table_row<<"-"
			end
		elsif homework_group.homework_type == "Marks"
                unless @homework.nil?
			  table_row<<"#{(homework_score.marks)} | #{(@homework.maximum_marks)}"
                 else
                  table_row<<"-"
                 end
		else
			  table_row<<homework_score.grading_level.name unless homework_score.nil?
			  @g = 0
		end
                else
                table_row<<"- "
	end
	total_score = homeworkScore.new()
	if @mmg == @g
                sub_total=total_score.grouped_homework_subject_total(subject,@student,@type,b)
         end

  end
table_row<<sub_total
    data<<table_row


end
  totals_row = Array.new()
  totals_row<<"Total"
  @max_total = 0
  @marks_total = 0
  @homework_groups.each do |homework_group|
		if homework_group.homework_type == "MarksAndGrades"
		  totals_row<<homework_group.total_marks(@student)[0]
		elsif homework_group.homework_type == "Marks"
		  totals_row<<homework_group.total_marks(@student)[0]
		else
		  totals_row<<"-"
		end
		unless homework_group.homework_type == "Grades"
		  @max_total = @max_total + homework_group.total_marks(@student)[1]
		  @marks_total = @marks_total + homework_group.total_marks(@student)[0]
		end
    end
totals_row<<"-"
data<<totals_row


col_widths[@homework_groups.size+1]=50
        pdf.move_down(100)
  pdf.text "Marklist for #{@student.full_name}  in  #{b.full_name}   "
    pdf.move_down(10)
      pdf.table data,
          :width=>500,
        :headers => table_header,
      :header_color => "eeeeee",
      :border_color => "000000",
      :position => :center,
      :font_size =>11,
      :row_colors => ["FFFFFF","DDDDDD"]

 pdf.start_new_page
   
   
     @additional_homework_groups = AdditionalhomeworkGroup.find_all_by_batch_id(b)
          @additional_homework_groups.each do |additional_homework_group|
              if additional_homework_group.students.include?(@student)
               data = Array.new(){Array.new()}
              @additional_homeworks = Additionalhomework.find_all_by_additional_homework_group_id(additional_homework_group)
              table_header = Array.new()
              table_header<<"Subject"
              table_header<<"Marks" unless additional_homework_group.homework_type == "Grades"
              table_header<<"Grades" unless additional_homework_group.homework_type == "Marks"
              @additional_homeworks.each do |homework|
                    unless (homework.score_for(@student).marks.nil? &&  homework.score_for(@student).grading_level_id.nil?)
                            table_row=Array.new()
                            table_row<<homework.subject.name
                            table_row<<homework.score_for(@student).marks      unless additional_homework_group.homework_type == "Grades"
                            table_row<< homework.score_for(@student).grading_level       unless additional_homework_group.homework_type == "Marks"
                            data<<table_row
                    end
             end
             unless data.empty?
                    pdf.move_down(100)
                    pdf.text "Marklist for #{@student.full_name}  in #{additional_homework_group.name} , #{b.full_name}   "
                    pdf.move_down(10)
                    pdf.table data,
                                    :width=>500,
                                     :headers => table_header,
                                      :column_widths =>{ 0 => 200},
                                     :header_color => "eeeeee",
                                     :border_color => "000000",
                                     :position => :center,
                                     :font_size =>11,
                                     :row_colors => ["FFFFFF","DDDDDD"]
                    pdf.start_new_page
            end
          end
      end

end


pdf.footer [pdf.margin_box.left, pdf.margin_box.bottom + 25] do
     pdf.font "Helvetica" do
        signature = [[""]]
        pdf.table signature, :width => 500,
                :align => {0 => :right,1 => :right},
                :headers => ["Signature"],
                :header_text_color  => "DDDDDD",
                :border_color => "FFFFFF",
                :position => :center
        pdf.move_down(20)
        pdf.stroke_horizontal_rule
    end
end