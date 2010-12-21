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


@homework_groups.each do |homework_group|
pdf.move_down(120)
data = Array.new(){Array.new()}
pdf.text homework_group.name+"-"+@subject.name , :size => 18 ,:at=>[10,620]
pdf.text homework_group.batch.name,:size => 12,:at=>[10,610]
  if homework_group.homework_type == 'Marks'
    data.push [ 'Student', 'Marks', 'Max Marks'  ]
  elsif homework_group.homework_type == 'Grades'
    data.push [ 'Student', 'Grades']
  else
    data.push [ 'Student', 'Marks', 'Max marks', 'Grades']
  end
  homework = homework.find_by_homework_group_id_and_subject_id(homework_group.id,@subject.id)
  @students.each do |student|
    homework_score = HomeworkScore.find_by_student_id(student.id,:conditions=>{:homework_id=>homework.id}) unless homework.nil?
    unless homework_score.nil?
      if homework_group.homework_type == 'Marks'
        data.push [ student.full_name, homework_score.marks, homework.maximum_marks  ]
      elsif homework_group.homework_type == 'Grades'
        data.push [ student.full_name, homework_score.grading_level.name]
      else
        data.push [ student.full_name,homework_score.marks, homework.maximum_marks, homework_score.grading_level.name]
      end
    else
      if homework_group.homework_type == 'Marks'
        data.push [ student.full_name, '-', '-'  ]


      elsif homework_group.homework_type == 'Grades'
        data.push [ student.full_name, '-']


      else
        data.push [ student.full_name,'-', '-', '-']


      end
    end
  end
  unless homework.nil?
    if homework_group.homework_type == 'Marks'
      data.push [ 'Average', homework_group.subject_wise_batch_average_marks(@subject.id),'-']
    elsif homework_group.homework_type == 'MarksAndGrades'

      data.push [ "Average",homework_group.subject_wise_batch_average_marks(@subject.id),  '-','-']

    else
      data.push [ "Average","-"]
    end
  end
  pdf.table data, :width => 500,
    :border_color => "000000",
    :position => :center,
    :font_size => 8,
    :column_widths => {0=>200,1=>100,2=>100,3=>100},
    :row_colors => ["FFFFFF","DDDDDD"]

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