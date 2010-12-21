class HomeworkController < ApplicationController
  before_filter :login_required
  before_filter :protect_other_student_data
  filter_access_to :all
  def index
  end

  def show
     @homework = Homework.find_by_subject_id(params[:id])
     send_data(@homework.data,
       :type => @homework.hw_content_type,
       :filename => @homework.hw_filename,
       :disposition => 'attachment')
   end
   
  def update_homework_form
   
    @batch = Batch.find(params[:batch])
    
    @name = params[:homework_option][:name]
    @type = params[:homework_option][:homework_type]

    unless @name == ''
      @homework_group = HomeworkGroup.new
      @normal_subjects = Subject.find_all_by_batch_id(@batch.id)
      @elective_subjects = []
      elective_subjects = Subject.find_all_by_batch_id(@batch.id)
      elective_subjects.each do |e|
        is_assigned = StudentsSubject.find_all_by_subject_id(e.id)
        unless is_assigned.empty?
          @elective_subjects.push e
        end
      end
      @all_subjects = @normal_subjects+@elective_subjects
      @all_subjects.each { |subject| @homework_group.homeworks.build(:subject_id => subject.id) }
      if @type == 'Marks' or @type == 'MarksAndGrades'
        render(:update) do |page|
          page.replace_html 'homework-form', :partial=>'homework_marks_form'
          page.replace_html 'flash', :text=>''
        end
      else
        render(:update) do |page|
          page.replace_html 'homework-form', :partial=>'homework_grade_form'
          page.replace_html 'flash', :text=>''
        end
      end
  
    else
      render(:update) do |page|
        page.replace_html 'flash', :text=>'<div class="errorExplanation"><p>homework name can\'t be blank</p></div>'
      end
    end
  end

  def publish
    @homework_group = HomeworkGroup.find(params[:id])
    @homeworks = @homework_group.homeworks
    @batch = @homework_group.batch
    @sms_setting_notice = ""
    @no_homework_notice = ""
    if params[:status] == "schedule"
      students = @batch.students
      
        students.each do |s|
          student_user = s.user
          Reminder.create(:sender=> current_user.id,:recipient=>student_user.id,
            :subject=>"homework Scheduled",
            :body=>"#{@homework_group.name} has been scheduled  <br/> Please view calendar for more details")
        end
      
    end
    unless @homeworks.empty?
      HomeworkGroup.update(@homework_group.id,:is_published=>true) if params[:status] == "schedule"
      HomeworkGroup.update(@homework_group.id,:result_published=>true) if params[:status] == "result"
      sms_setting = SmsSetting.new()
      if sms_setting.application_sms_active and sms_setting.homework_result_schedule_sms_active
        students = @batch.students
        students.each do |s|
          guardian = s.immediate_contact
          recipients = []
          if s.is_sms_enabled
            if sms_setting.student_sms_active
              recipients.push s.phone2 unless s.phone2.nil?
            end
            if sms_setting.parent_sms_active
              unless guardian.nil?
              recipients.push guardian.mobile_phone unless guardian.mobile_phone.nil?
              end
            end
            @message = "#{@homework_group.name} homework Timetable has been published." if params[:status] == "schedule"
            @message = "#{@homework_group.name} homework result has been published." if params[:status] == "result"
            unless recipients.empty?
              sms = SmsManager.new(@message,recipients)
              sms.send_sms
            end
          end
        end
      else
        @conf = Configuration.available_modules
        if @conf.include?('SMS')
          @sms_setting_notice = "homework schedule published, No sms was sent as Sms setting was not activated" if params[:status] == "schedule"
          @sms_setting_notice = "homework result published, No sms was sent as Sms setting was not activated" if params[:status] == "result"
        else
          @sms_setting_notice = "homework schedule published" if params[:status] == "schedule"
          @sms_setting_notice = "homework result published" if params[:status] == "result"
        end
      end
      if params[:status] == "result"
        students = @batch.students
        students.each do |s|
          student_user = s.user
          Reminder.create(:sender=> current_user.id,:recipient=>student_user.id,
            :subject=>"Result Published",
            :body=>"#{@homework_group.name} result has been published  <br/> Please view reports for your result")
        end
      end
    else
      @no_homework_notice = "homework scheduling not done yet."
    end
  end

  def grouping
    @batch = Batch.find(params[:id])
    @homework_groups = HomeworkGroup.find_all_by_batch_id(@batch.id)
    if request.post?
      unless params[:homework_grouping].nil?
        unless params[:homework_grouping][:homework_group_ids].nil?
          Groupedhomework.delete_all(:batch_id=>@batch.id)
          homework_group_ids = params[:homework_grouping][:homework_group_ids]
          homework_group_ids.each do |e|
            Groupedhomework.create(:homework_group_id=>e,:batch_id=>@batch.id)
          end
        end
      else
        Groupedhomework.delete_all(:batch_id=>@batch.id)
      end
        flash[:notice]="Selected homeworks grouped successfully."
    end
  end

  #REPORTS

  def homework_wise_report
    @batches = Batch.active
    @homework_groups = []
  end

  def list_homework_types
    batch = Batch.find(params[:batch_id])
    @homework_groups = HomeworkGroup.find_all_by_batch_id(batch.id)
    render(:update) do |page|
      page.replace_html 'homework-group-select', :partial=>'homework_group_select'
    end
  end

  def generated_report
    if params[:student].nil?
      if params[:homework_report].nil? or params[:homework_report][:homework_group_id].empty?
        flash[:notice] = "Select a batch and homework to continue."
        redirect_to :action=>'homework_wise_report' and return
      end
    else
      if params[:homework_group].nil?
        flash[:notice] = "Invalid parameters."
        redirect_to :action=>'homework_wise_report' and return
      end
    end
    if params[:student].nil?
      @homework_group = HomeworkGroup.find(params[:homework_report][:homework_group_id])
      @batch = @homework_group.batch
      @student = @batch.students.first
      general_subjects = Subject.find_all_by_batch_id(@batch.id, :conditions=>"elective_group_id IS NULL")
      student_electives = StudentsSubject.find_all_by_student_id(@student.id,:conditions=>"batch_id = #{@batch.id}")
      elective_subjects = []
      student_electives.each do |elect|
        elective_subjects.push Subject.find(elect.subject_id)
      end
      @subjects = general_subjects + elective_subjects
      @homeworks = []
      @subjects.each do |sub|
        homework = Homework.find_by_homework_group_id_and_subject_id(@homework_group.id,sub.id)
        @homeworks.push homework unless homework.nil?
      end
      @graph = open_flash_chart_object(770, 350,
        "/homework/graph_for_generated_report?batch=#{@student.batch.id}&HomeworkGroup=#{@homework_group.id}&student=#{@student.id}")
    else
      @homework_group = HomeworkGroup.find(params[:homework_group])
      @student = Student.find(params[:student])
      @batch = @student.batch
      general_subjects = Subject.find_all_by_batch_id(@student.batch.id, :conditions=>"elective_group_id IS NULL")
      student_electives = StudentsSubject.find_all_by_student_id(@student.id,:conditions=>"batch_id = #{@student.batch.id}")
      elective_subjects = []
      student_electives.each do |elect|
        elective_subjects.push Subject.find(elect.subject_id)
      end
      @subjects = general_subjects + elective_subjects
      @homeworks = []
      @subjects.each do |sub|
        homework = Homework.find_by_homework_group_id_and_subject_id(@homework_group.id,sub.id)
        @homeworks.push homework unless homework.nil?
      end
      @graph = open_flash_chart_object(770, 350,
        "/homework/graph_for_generated_report?batch=#{@student.batch.id}&HomeworkGroup=#{@homework_group.id}&student=#{@student.id}")
    end
  end
  def generated_report_pdf
    @config = Configuration.get_config_value('InstitutionName')
    @homework_group = HomeworkGroup.find(params[:homework_group])
    @batch = Batch.find(params[:batch])
    @students = @batch.students
    respond_to do |format|
      format.pdf { render :layout => false }
    end
  end


  def consolidated_homework_report
    @homework_group = HomeworkGroup.find(params[:homework_group])
  end

  def consolidated_homework_report_pdf
    @homework_group = HomeworkGroup.find(params[:homework_group])
    respond_to do |format|
      format.pdf { render :layout => false }
    end
  end

  def subject_wise_report
    @batches = Batch.active
    @subjects = []
  end

  def list_subjects
    @subjects = Subject.find_all_by_batch_id(params[:batch_id],:conditions=>"is_deleted=false")
    render(:update) do |page|
      page.replace_html 'subject-select', :partial=>'subject_select'
    end
  end

  def generated_report2
    #subject-wise-report-for-batch
    unless params[:homework_report][:subject_id] == ""
      @subject = Subject.find(params[:homework_report][:subject_id])
      @batch = @subject.batch
      @students = @batch.students
      @homework_groups = HomeworkGroup.find(:all,:conditions=>{:batch_id=>@batch.id})
    else
      flash[:notice] = "select a subject to continue"
      redirect_to :action=>'subject_wise_report'
    end
  end
  def generated_report2_pdf
    #subject-wise-report-for-batch
    @subject = Subject.find(params[:subject_id])
    @batch = @subject.batch
    @students = @batch.students
    @homework_groups = HomeworkGroup.find(:all,:conditions=>{:batch_id=>@batch.id})
    respond_to do |format|
      format.pdf { render :layout => false }
    end
  end

  def generated_report3
    #student-subject-wise-report
    @student = Student.find(params[:student])
    @batch = @student.batch
    @subject = Subject.find(params[:subject])
    @homework_groups = HomeworkGroup.find(:all,:conditions=>{:batch_id=>@batch.id})
    @graph = open_flash_chart_object(770, 350,
      "/homework/graph_for_generated_report3?subject=#{@subject.id}&student=#{@student.id}")
  end

  def final_report_type
    batch = Batch.find(params[:batch_id])
    @grouped_homeworks = Groupedhomework.find_all_by_batch_id(batch.id)
    render(:update) do |page|
      page.replace_html 'report_type',:partial=>'report_type'
    end
  end

  def generated_report4
    if params[:student].nil?
      if params[:homework_report].nil? or params[:homework_report][:batch_id].empty?
        flash[:notice] = "Select a batch to continue"
        redirect_to :action=>'grouped_homework_report' and return
      end
    else
      if params[:type].nil?
        flash[:notice] = "Invalid parameters."
        redirect_to :action=>'grouped_homework_report' and return
      end
    end
    #grouped-homework-report-for-batch
    if params[:student].nil?
      @type = params[:type]
      @batch = Batch.find(params[:homework_report][:batch_id])
      @student = @batch.students.first
      if @type == 'grouped'
        @grouped_homeworks = Groupedhomework.find_all_by_batch_id(@batch.id)
        @homework_groups = []
        @grouped_homeworks.each do |x|
          @homework_groups.push HomeworkGroup.find(x.homework_group_id)
        end
      else
        @homework_groups = HomeworkGroup.find_all_by_batch_id(@batch.id)
      end
      general_subjects = Subject.find_all_by_batch_id(@batch.id, :conditions=>"elective_group_id IS NULL AND is_deleted=false")
      student_electives = StudentsSubject.find_all_by_student_id(@student.id,:conditions=>"batch_id = #{@batch.id}")
      elective_subjects = []
      student_electives.each do |elect|
        elective_subjects.push Subject.find(elect.subject_id)
      end
      @subjects = general_subjects + elective_subjects
    else
      @student = Student.find(params[:student])
      @batch = @student.batch
      @type  = params[:type]
      if params[:type] == 'grouped'
        @grouped_homeworks = Groupedhomework.find_all_by_batch_id(@batch.id)
        @homework_groups = []
        @grouped_homeworks.each do |x|
          @homework_groups.push HomeworkGroup.find(x.homework_group_id)
        end
      else
        @homework_groups = HomeworkGroup.find_all_by_batch_id(@batch.id)
      end
      general_subjects = Subject.find_all_by_batch_id(@student.batch.id, :conditions=>"elective_group_id IS NULL AND is_deleted=false")
      student_electives = StudentsSubject.find_all_by_student_id(@student.id,:conditions=>"batch_id = #{@student.batch.id}")
      elective_subjects = []
      student_electives.each do |elect|
        elective_subjects.push Subject.find(elect.subject_id)
      end
      @subjects = general_subjects + elective_subjects
    end


  end
  def generated_report4_pdf

    #grouped-homework-report-for-batch
    if params[:student].nil?
      @type = params[:type]
      @batch = Batch.find(params[:homework_report][:batch_id])
      @student = @batch.students.first
      if @type == 'grouped'
        @grouped_homeworks = Groupedhomework.find_all_by_batch_id(@batch.id)
        @homework_groups = []
        @grouped_homeworks.each do |x|
          @homework_groups.push HomeworkGroup.find(x.homework_group_id)
        end
      else
        @homework_groups = HomeworkGroup.find_all_by_batch_id(@batch.id)
      end
      general_subjects = Subject.find_all_by_batch_id(@batch.id, :conditions=>"elective_group_id IS NULL")
      student_electives = StudentsSubject.find_all_by_student_id(@student.id,:conditions=>"batch_id = #{@batch.id}")
      elective_subjects = []
      student_electives.each do |elect|
        elective_subjects.push Subject.find(elect.subject_id)
      end
      @subjects = general_subjects + elective_subjects
    else
      @student = Student.find(params[:student])
      @batch = @student.batch
      @type  = params[:type]
      if params[:type] == 'grouped'
        @grouped_homeworks = Groupedhomework.find_all_by_batch_id(@batch.id)
        @homework_groups = []
        @grouped_homeworks.each do |x|
          @homework_groups.push HomeworkGroup.find(x.homework_group_id)
        end
      else
        @homework_groups = HomeworkGroup.find_all_by_batch_id(@batch.id)
      end
      general_subjects = Subject.find_all_by_batch_id(@student.batch.id, :conditions=>"elective_group_id IS NULL")
      student_electives = StudentsSubject.find_all_by_student_id(@student.id,:conditions=>"batch_id = #{@student.batch.id}")
      elective_subjects = []
      student_electives.each do |elect|
        elective_subjects.push Subject.find(elect.subject_id)
      end
      @subjects = general_subjects + elective_subjects
    end
    respond_to do |format|
      format.pdf { render :layout => false }
    end

  end

  def previous_years_marks_overview
    @student = Student.find(params[:student])
    @all_batches = @student.all_batches
    @graph = open_flash_chart_object(770, 350,
      "/homework/graph_for_previous_years_marks_overview?student=#{params[:student]}&graphtype=#{params[:graphtype]}")
    respond_to do |format|
      format.pdf { render :layout => false }
      format.html
    end
  end

  def academic_report
    #academic-archived-report
    @student = Student.find(params[:student])
    @batch = Batch.find(params[:year])
    if params[:type] == 'grouped'
      @grouped_homeworks = Groupedhomework.find_all_by_batch_id(@batch.id)
      @homework_groups = []
      @grouped_homeworks.each do |x|
        @homework_groups.push HomeworkGroup.find(x.homework_group_id)
      end
    else
      @homework_groups = HomeworkGroup.find_all_by_batch_id(@batch.id)
    end
    general_subjects = Subject.find_all_by_batch_id(@batch.id, :conditions=>"elective_group_id IS NULL and is_deleted=false")
    student_electives = StudentsSubject.find_all_by_student_id(@student.id,:conditions=>"batch_id = #{@batch.id}")
    elective_subjects = []
    student_electives.each do |elect|
      elective_subjects.push Subject.find(elect.subject_id)
    end
    @subjects = general_subjects + elective_subjects
  end

  def create_homework
    @course= Course.active
  end

  def update_batch_ex_result
    @batch = Batch.find_all_by_course_id(params[:course_name], :conditions => { :is_deleted => false, :is_active => true })

    render(:update) do |page|
      page.replace_html 'update_batch', :partial=>'update_batch_ex_result'
    end
  end

  def update_batch
    @batch = Batch.find_all_by_course_id(params[:course_name], :conditions => { :is_deleted => false, :is_active => true })

    render(:update) do |page|
      page.replace_html 'update_batch', :partial=>'update_batch'
    end

  end

  
  #GRAPHS

  def graph_for_generated_report
    student = Student.find(params[:student])
    homeworkgroup = HomeworkGroup.find(params[:HomeworkGroup])
    batch = student.batch
    general_subjects = Subject.find_all_by_batch_id(batch.id, :conditions=>"elective_group_id IS NULL")
    student_electives = StudentsSubject.find_all_by_student_id(student.id,:conditions=>"batch_id = #{batch.id}")
    elective_subjects = []
    student_electives.each do |elect|
      elective_subjects.push Subject.find(elect.subject_id)
    end
    subjects = general_subjects + elective_subjects

    x_labels = []
    data = []
    data2 = []

    subjects.each do |s|
      homework = Homework.find_by_homework_group_id_and_subject_id(HomeworkGroup.id,s.id)
      res = HomeworkScore.find_by_homework_id_and_student_id(homework, student)
      unless res.nil?
        x_labels << s.code
        data << res.marks
        data2 << homework.class_average_marks
      end
    end

    bargraph = BarFilled.new()
    bargraph.width = 1;
    bargraph.colour = '#bb0000';
    bargraph.dot_size = 5;
    bargraph.text = "Student's marks"
    bargraph.values = data

    bargraph2 = BarFilled.new
    bargraph2.width = 1;
    bargraph2.colour = '#5E4725';
    bargraph2.dot_size = 5;
    bargraph2.text = "Class average"
    bargraph2.values = data2

    x_axis = XAxis.new
    x_axis.labels = x_labels

    y_axis = YAxis.new
    y_axis.set_range(0,100,20)

    title = Title.new(student.full_name)

    x_legend = XLegend.new("Subjects")
    x_legend.set_style('{font-size: 14px; color: #778877}')

    y_legend = YLegend.new("Marks")
    y_legend.set_style('{font-size: 14px; color: #770077}')

    chart = OpenFlashChart.new
    chart.set_title(title)
    chart.y_axis = y_axis
    chart.x_axis = x_axis
    chart.y_legend = y_legend
    chart.x_legend = x_legend

    chart.add_element(bargraph)
    chart.add_element(bargraph2)

    render :text => chart.render
  end

  def graph_for_generated_report3
    student = Student.find params[:student]
    subject = Subject.find params[:subject]
    homeworks = Homework.find_all_by_subject_id(subject.id, :order => 'start_time asc')

    data = []
    x_labels = []

    homeworks.each do |e|
      homework_result = HomeworkScore.find_by_homework_id_and_student_id(e, student.id)
      unless homework_result.nil?
        data << homework_result.marks
        x_labels << XAxisLabel.new(homework_result.homework.homework_group.name, '#000000', 10, 0)
      end
    end

    x_axis = XAxis.new
    x_axis.labels = x_labels

    line = BarFilled.new

    line.width = 1
    line.colour = '#5E4725'
    line.dot_size = 5
    line.values = data

    y = YAxis.new
    y.set_range(0,100,20)

    title = Title.new(subject.name)

    x_legend = XLegend.new("homework")
    x_legend.set_style('{font-size: 14px; color: #778877}')

    y_legend = YLegend.new("Marks")
    y_legend.set_style('{font-size: 14px; color: #770077}')

    chart = OpenFlashChart.new
    chart.set_title(title)
    chart.set_x_legend(x_legend)
    chart.set_y_legend(y_legend)
    chart.y_axis = y
    chart.x_axis = x_axis

    chart.add_element(line)

    render :text => chart.to_s
  end

  def graph_for_previous_years_marks_overview
    student = Student.find(params[:student])

    x_labels = []
    data = []

    student.all_batches.each do |b|
      x_labels << b.name
      homework = HomeworkScore.new()
      data << homework.batch_wise_aggregate(student,b)
    end

    if params[:graphtype] == 'Line'
      line = Line.new
    else
      line = BarFilled.new
    end

    line.width = 1; line.colour = '#5E4725'; line.dot_size = 5; line.values = data

    x_axis = XAxis.new
    x_axis.labels = x_labels

    y_axis = YAxis.new
    y_axis.set_range(0,100,20)

    title = Title.new(student.full_name)

    x_legend = XLegend.new("Academic year")
    x_legend.set_style('{font-size: 14px; color: #778877}')

    y_legend = YLegend.new("Total marks")
    y_legend.set_style('{font-size: 14px; color: #770077}')

    chart = OpenFlashChart.new
    chart.set_title(title)
    chart.y_axis = y_axis
    chart.x_axis = x_axis

    chart.add_element(line)

    render :text => chart.to_s
  end

end

