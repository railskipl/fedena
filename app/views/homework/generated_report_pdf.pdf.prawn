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

@students.each do |student|
  pdf.move_down(80)
  pdf.text "Student wise report for "+@homework_group.name+", Batch:"+@batch.name
  pdf.move_down(10)
  pdf.stroke_horizontal_rule
  pdf.move_down(20)
  pdf.text student.full_name , :size => 18
  pdf.text "homework :"+@homework_group.name,:size => 7
  data = Array.new(){Array.new()}
  pdf.move_down(20)
  if @homework_group.homework_type == 'Marks'
    data.push ["Subject","Marks","Maximum marks","Percentage"]
    total_marks = 0
    total_max_marks = 0
    @homework_group.homeworks.each do |homework|
      homework_score = HomeworkScore.find_by_student_id_and_homework_id(student,homework)
      unless homework_score.nil?
        mark = homework_score.marks
        total_marks += mark
        total_max_marks += homework.maximum_marks
      else
        mark = "-"
      end
      data.push [homework.subject.name,mark,homework.maximum_marks,(homework_score.calculate_percentage unless homework_score.nil?)]
    end
    pdf.table data, :width => 500,
      :border_color => "000000",
      :position => :center,
      :font_size => 8,
      :column_widths => {0=>200,1=>100,2=>100,3=>100},
      :align => {0=>:left,1=>:center,2=>:center,3=>:center},
      :row_colors => ["FFFFFF","DDDDDD"]


  elsif @homework_group.homework_type == 'Grades'
    data.push ["Subject","Grade"]
    @homework_group.homeworks.each do |homework|
      homework_score = HomeworkScore.find_by_student_id_and_homework_id(student,homework)
      unless homework_score.nil?
      data.push [homework.subject.name,homework_score.grading_level.name]
      else
      data.push [homework.subject.name,"-"]
      end
    end
    pdf.table data, :width => 500,
      :border_color => "000000",
      :position => :center,
      :font_size => 8,
      :column_widths => {0=>200,1=>100,2=>100,3=>100},
      :align => {0=>:left,1=>:center,2=>:center,3=>:center},
      :row_colors => ["FFFFFF","DDDDDD"]

  else
    data.push ["Subject","Marks","Grade","Maximum marks","Percentage"]
    total_marks = 0
    total_max_marks = 0
    @homework_group.homeworks.each do |homework|
      homework_score = HomeworkScore.find_by_student_id_and_homework_id(student,homework)
      unless homework_score.nil?
        mark = homework_score.marks
        grade = homework_score.grading_level.name
        total_marks += mark
        total_max_marks += homework.maximum_marks
      else
        mark = "-"
        grade = "-"
      end
      data.push [homework.subject.name,mark,grade,homework.maximum_marks,(homework_score.calculate_percentage unless homework_score.nil?)]
    end
    pdf.table data, :width => 500,
      :border_color => "000000",
      :header_color => "eeeeee",
      :position => :center,
      :font_size => 8,
      :column_widths => {0=>200,1=>75,2=>75,3=>75,4=>100},
      :align => {0=>:left,1=>:center,2=>:center,3=>:center,4=>:center},
      :row_colors => ["FFFFFF","DDDDDD"]

  end


  pdf.start_new_page
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
