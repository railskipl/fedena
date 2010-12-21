class HomeworkResultController < ApplicationController

#  before_filter :login_required
#  filter_access_to :all
#
#  def add
#    @courses = AcademicYear.this.courses
#    @course1 = @courses[0] unless @courses.nil?
#    @subjects = []
#    @homeworks = []
#  end
#
#  def add_results
#    @e_id = params[:homework_result][:homework_id]
#    @c_id = homework.find(@e_id).subject.course
#    @students = Student.find_all_by_course_id(@c_id)
#  end
#
#  def save
#    @homework_id = params[:homework_id]
#    @results = params["homework_result"]
#    @homework = homework.find(@homework_id)
#    @results.each_pair do |s_id, m|
#      unless ( (r = homeworkResult.find_by_homework_id_and_student_id(@homework_id, s_id)) == nil )
#        unless m["marks"] == ""
#          marks = m["marks"]
#          percentage = marks.to_i * 100 / @homework.max_marks
#          g_id = Grading.find(:first, :conditions => "min_score <= #{percentage.round}", :order => "min_score desc").id
#        end
#        homeworkResult.update(r.id, { :marks => marks, :grading_id => g_id, :student_id => s_id, :homework_id => @homework_id } )
#      else
#        r1 = homeworkResult.new
#        unless m["marks"] == ""
#          r1.marks = m["marks"]
#          percentage = r1.marks.to_i * 100 / @homework.max_marks
#          r1.grading_id = Grading.find(:first, :conditions => "min_score <= #{percentage.round}", :order => "min_score desc").id
#        end
#        r1.student_id = s_id
#        r1.homework_id = @homework_id
#        r1.save
#      end
#    end
#    redirect_to :controller => "homework_result", :action => "add"
#  end
#
#  def update_subjects
#    course = Course.find(params[:course_id]) unless params[:course_id] == ''
#    if course
#      @subjects = Subject.find_all_by_course_id(course.id)
#    else
#      @subjects = []
#    end
#    @homeworks = []
#    render :update do |page|
#      page.replace_html 'subjects1', :partial => 'subjects', :object => @subjects
#      page.replace_html 'homeworks1', :partial => 'homeworks', :object => @homeworks
#    end
#  end
#
#  def update_one_subject
#    course = Course.find(params[:course_id]) unless params[:course_id] == ''
#    if course
#      @subjects = Subject.find_all_by_course_id(course.id)
#    else
#      @subjects = []
#    end
#    @homeworks = []
#    render :update do |page|
#      page.replace_html 'subjects1', :partial => 'one_sub', :object => @subjects
#      page.replace_html 'homeworks1', :partial => 'one_sub_homeworks', :object => @homeworks
#    end
#  end
#
#  def update_homeworks
#    subject = Subject.find(params[:subject_id]) unless params[:subject_id] == ''
#    if subject
#      @homeworks = subject.homeworks
#    else
#      @homeworks=[]
#    end
#    render :update do |page|
#      page.replace_html 'homeworks1', :partial => 'homeworks', :object => @homeworks
#    end
#  end
#
#  def update_one_sub_homeworks
#    subject = Subject.find(params[:subject_id]) unless params[:subject_id] == ''
#    if subject
#      @homeworks = subject.homeworks
#    else
#      @homeworks=[]
#    end
#    render :update do |page|
#      page.replace_html 'homeworks1', :partial => 'one_sub_homeworks', :object => @homeworks
#    end
#  end
#
#  def load_results
#    @exm = homework.find(params[:homework_id])
#    @students = @exm.subject.course.students.active
#
#    render :update do |page|
#      page.replace_html 'homework_result', :partial => 'homework_result'
#    end
#  end
#
#  def load_one_sub_result
#    @exm = homework.find(params[:homework_id])
#    @students = @exm.subject.course.students.active
#    render :update do |page|
#      page.replace_html 'homework_result', :partial => 'one_sub_homework_result'
#    end
#  end
#
#  def load_all_sub_result
#    @course   = Course.find(params[:course_id])
#    @homeworktype = homeworkType.find(params[:homework_type_id])
#    @subjects = @course.subjects
#    @students = Student.find_all_by_course_id(@course.id,:conditions=>"status = 'Active'")
#    @homeworks    = homework.find_all_by_homework_type_id_and_subject_id(@homeworktype.id, @subjects.collect{|x| x})
#    @res      = homeworkResult.find_all_by_homework_id(@homeworks)
#    render :update do |page|
#      page.replace_html 'homework_result', :partial => 'all_sub_homework_result'
#    end
#  end
#
#  def update_homeworktypes
#    subs = Subject.find_all_by_course_id(params[:course_id])
#    homeworks = homework.find_all_by_subject_id(subs, :select => "DISTINCT homework_type_id")
#    etype_ids = homeworks.collect { |x| x.homework_type_id }
#    @homeworktypes = homeworkType.find(etype_ids)
#
#    render :update do |page|
#      page.replace_html "homeworktypes1", :partial => "homeworktypes", :object => @homeworktypes
#    end
#  end
#
#  def view_all_subs
#    @courses = AcademicYear.this.courses
#    @homeworktypes = []
#
#    if request.post?
#      if params[:homework_result][:homeworktype_id] == ""
#        flash[:notice] = "Please select an homework type"
#        redirect_to :action => "view_all_subs"
#        return
#      end
#      case params[:commit]
#      when "View"
#        @course   = Course.find(params[:homework_result][:course_id])
#        @homeworktype = homeworkType.find(params[:homework_result][:homeworktype_id])
#        @subjects = @course.subjects
#        @students = Student.find_all_by_course_id(@course.id)
#        @homeworks    = homework.find_all_by_homework_type_id(@homeworktype.id)
#      when "Generate PDF Report"
#        course   = params[:homework_result][:course_id]
#        homeworktype = params[:homework_result][:homeworktype_id]
#        subjects = Subject.find_all_by_course_id(course)
#        students = Student.find_all_by_course_id(course, :order => "first_name ASC")
#        homeworks    = homework.find_all_by_homework_type_id_and_subject_id(homeworktype, subjects)
#        res      = homeworkResult.find_all_by_homework_id(homeworks)
#
#        _p = PDF::Writer.new
#        _p.text(homeworkType.find(homeworktype).name, :font_size => 20, :justification => :center)
#        this_course = Course.find(course)
#        unless this_course.nil?
#          _p.text("Class : " + this_course.grade + " - " + this_course.section, :font_size => 14, :justification => :center)
#        end
#        _p.text(" ", :font_size => 20, :justification => :center)
#        PDF::SimpleTable.new do |t|
#          t.column_order.push("Name")
#          subjects.each {|s| t.column_order.push(s.name)}
#          students.each do |st|
#            x = {"Name"  => st.first_name + " " + st.last_name}
#            subjects.each do |sub|
#              homework = homework.find_by_subject_id_and_homework_type_id(sub.id, homeworktype)
#              unless homework.nil?
#                homeworkres = homeworkResult.find_by_homework_id_and_student_id(homework.id, st.id)
#                x[sub.name] = homeworkres.marks unless homeworkres.nil?
#              end
#            end
#            t.data << x
#          end
#          t.render_on(_p) unless res.nil?
#        end
#        send_data _p.render, :filename => "report.pdf", :type => "application/pdf", :disposition => 'inline'
#      end
#    end
#  end
#
#  def view_one_sub
#    @courses = AcademicYear.this.courses
#    @subjects = []
#    @homeworks = []
#    if request.post?
#      if params[:homework_result][:homework_id] == ""
#        flash[:notice] = "Please select an homework."
#        redirect_to :action => "view_one_sub"
#        return
#      end
#
#      @homework_id = params[:homework_result][:homework_id]
#      return if @homework_id == ""
#
#      case params[:commit]
#      when "View"
#        @results = homeworkResult.find_all_by_homework_id(@homework_id)
#        @homework = homework.find(@homework_id)
#        @selected_course = @homework.subject.course
#        @subjects = @selected_course.subjects
#        @selected_subject = @homework.subject
#        @homeworks = @selected_subject.homeworks
#
#        @sel_course_id = @selected_course.id
#        @sel_subject_id = @selected_subject.id
#        @sel_homework_id = @homework.id
#      when "Generate PDF Report"
#        results = homeworkResult.find_all_by_homework_id(@homework_id)
#        homework = homework.find(@homework_id)
#        _p = PDF::Writer.new
#        _p.text(homework.homework_type.name, :font_size => 20, :justification => :center)
#        _p.text(homework.subject.course.grade + " " + homework.subject.course.section, :font_size => 16, :justification => :center)
#        _p.text(" ", :font_size => 20, :justification => :center)
#        PDF::SimpleTable.new do |t|
#          t.column_order.push("Name", "Marks", "Grade")
#          results.each { |r| t.data << {"Name"  => r.student.first_name + " " + r.student.last_name,
#              "Marks" => r.marks, "Grade" => r.grading.name } }
#          t.render_on(_p) unless t.nil?
#        end
#        send_data _p.render, :filename => "hello.pdf", :type => "application/pdf", :disposition => 'inline'
#      end
#    end
#  end
#
#  # pdf-generation
#
#  def one_sub_pdf
#    @institute_name = Configuration.find_by_config_key("SchoolCollegeName")
#    @exm = homework.find(params[:id])
#    @students = @exm.subject.course.students
#    @i = 0
#    respond_to do |format|
#      format.pdf { render :layout => false }
#    end
#  end
#
#  def all_sub_pdf
#    @course   = Course.find(params[:id])
#    @homeworktype = homeworkType.find(params[:id2])
#    @subjects = @course.subjects
#    @students = Student.find_all_by_course_id(@course.id)
#    @homeworks    = homework.find_all_by_homework_type_id_and_subject_id(@homeworktype.id, @subjects.collect{|x| x})
#    @res      = homeworkResult.find_all_by_homework_id(@homeworks)
#    @i = 1
#    respond_to do |format|
#      format.pdf { render :layout => false }
#    end
#  end
#
#  def academic_report_course
#    @user = current_user
#    @courses = AcademicYear.this.courses
#  end
#
#  def list_students_by_course
#    @students = Student.find_all_by_course_id(params[:course_id], :conditions=>"status = 'Active'",:order => 'first_name ASC')
#    render(:update) { |page| page.replace_html 'result', :partial => 'students_by_course' }
#  end
#
#  def all_academic_report
#    @student = Student.find(params[:id])
#    course = @student.course
#    @prev_student = @student.previous_student
#    @next_student = @student.next_student
#    @homeworktypes = homeworkType.find( ( course.homeworks.collect { |x| x.homework_type_id } ).uniq )
#    @graph = open_flash_chart_object(965, 350,
#      "/student/graph_for_academic_report?course=#{course.id}&student=#{@student.id}")
#    @graph2 = open_flash_chart_object(965, 350,
#      "/student/graph_for_annual_academic_report?course=#{course.id}&student=#{@student.id}")
#  end
#
#  def homework_wise_report
#    @courses = AcademicYear.this.courses
#    @homeworktypes = []
#  end
#
#  def load_homeworktypes
#    subs = Subject.find_all_by_course_id(params[:course_id])
#    homeworks = homework.find_all_by_subject_id(subs, :select => "DISTINCT homework_type_id")
#    etype_ids = homeworks.collect { |x| x.homework_type_id }
#    @homeworktypes = homeworkType.find(etype_ids)
#
#    render :update do |page|
#      page.replace_html "homeworktypes1", :partial => "load_homeworktypes", :object => @homeworktypes
#    end
#  end
#
#  def load_course_all_student
#    @homeworktype = homeworkType.find(params[:homework_type_id])
#    @course = Course.find(params[:course_id])
#    @students = Student.find_all_by_course_id(params[:course_id], :conditions=>"status = 'Active'",:order => 'first_name ASC')
#    render(:update) { |page| page.replace_html 'student', :partial => 'load_course_student' }
#  end
#
#  def homework_report
#    @user = current_user
#    @homeworktype = homeworkType.find(params[:homework])
#    @course = Course.find(params[:course])
#    @student = Student.find(params[:student]) if params[:student]
#    @student ||= @course.students.first
#    @prev_student = @student.previous_student
#    @next_student = @student.next_student
#    @subjects = @course.subjects_with_homeworks
#    @results = {}
#    @subjects.each do |s|
#      homework = homework.find_by_subject_id_and_homework_type_id(s, @homeworktype)
#      res = homeworkResult.find_by_homework_id_and_student_id(homework, @student)
#      @results[s.id.to_s] = { 'subject' => s, 'result' => res } unless res.nil?
#    end
#    @graph = open_flash_chart_object(770, 350,
#      "/student/graph_for_homework_report?course=#{@course.id}&homeworktype=#{@homeworktype.id}&student=#{@student.id}")
#  end
#
#  def graph_for_homework_report
#    student = Student.find(params[:student])
#    homeworktype = homeworkType.find(params[:homeworktype])
#    course = student.course
#    subjects = course.subjects_with_homeworks
#
#    x_labels = []
#    data = []
#    data2 = []
#
#    subjects.each do |s|
#      homework = homework.find_by_subject_id_and_homework_type_id(s, homeworktype)
#      res = homeworkResult.find_by_homework_id_and_student_id(homework, student)
#      unless res.nil?
#        x_labels << s.name
#        data << res.percentage_marks
#        data2 << homework.average_marks * 100 / homework.max_marks
#      end
#    end
#
#    bargraph = BarFilled.new()
#    bargraph.width = 1;
#    bargraph.colour = '#bb0000';
#    bargraph.dot_size = 5;
#    bargraph.text = "Student's marks"
#    bargraph.values = data
#
#    bargraph2 = BarFilled.new
#    bargraph2.width = 1;
#    bargraph2.colour = '#5E4725';
#    bargraph2.dot_size = 5;
#    bargraph2.text = "Class average"
#    bargraph2.values = data2
#
#    x_axis = XAxis.new
#    x_axis.labels = x_labels
#
#    y_axis = YAxis.new
#    y_axis.set_range(0,100,20)
#
#    title = Title.new(student.full_name)
#
#    x_legend = XLegend.new("Academic year")
#    x_legend.set_style('{font-size: 14px; color: #778877}')
#
#    y_legend = YLegend.new("Total marks")
#    y_legend.set_style('{font-size: 14px; color: #770077}')
#
#    chart = OpenFlashChart.new
#    chart.set_title(title)
#    chart.y_axis = y_axis
#    chart.x_axis = x_axis
#    chart.y_legend = y_legend
#    chart.x_legend = x_legend
#
#    chart.add_element(bargraph)
#    chart.add_element(bargraph2)
#
#    render :text => chart.render
#  end
#
end