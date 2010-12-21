class HomeworksController < ApplicationController
  before_filter :query_data
  filter_access_to :all
  def new
    @homework = Homework.new
    @subjects = @batch.subjects
  end

  def create
   
    @homework = Homework.new(params[:homework])
    @homework.homework_group_id = @homework_group.id
    @homework.image_file = params[:homework]
    if @homework.save
      flash[:notice] = "New homework created successfully."
      redirect_to [@batch, @homework_group]
    else
      @subjects = @batch.subjects
      render 'new'
    end
  end

  def edit
    @homework = Homework.find params[:id], :include => :homework_group
    @subjects = @homework_group.batch.subjects
  end

  def update
    @homework = Homework.find params[:id], :include => :homework_group

    if @homework.update_attributes(params[:homework])
      flash[:notice] = 'Updated homework details successfully.'
      redirect_to [@homework_group, @homework]
    else
      render 'edit'
    end
  end

  def show
    @homework = Homework.find params[:id], :include => :homework_group
    homework_subject = Subject.find(@homework.subject_id)
    is_elective = homework_subject.elective_group_id
    if is_elective == nil
    @students = @batch.students
    else
      assigned_students = StudentsSubject.find_all_by_subject_id(homework_subject.id)
      @students = []
      assigned_students.each do |s|
        student = Student.find_by_id(s.student_id)
        @students.push student unless student.nil?
      end
    end
    @config = Configuration.get_config_value('homeworkResultType') || 'Marks'

    @grades = @batch.grading_level_list
  end

  def destroy
    @homework = Homework.find params[:id], :include => :homework_group
    batch_id = @homework.homework_group.batch_id
    batch_event = BatchEvent.find_by_event_id_and_batch_id(@homework.event_id,batch_id)
    event = Event.find(@homework.event_id)
    event.destroy
    batch_event.destroy
    @homework.destroy
    redirect_to [@batch, @homework_group]
  end

  def save_scores
    @homework = Homework.find(params[:id])
    params[:homework].each_pair do |student_id, details|
      @homework_score = HomeworkScore.find(:first, :conditions => {:homework_id => @homework.id, :student_id => student_id} )
      if @homework_score.nil?
        HomeworkScore.create do |score|
          score.homework_id          = @homework.id
          score.student_id       = student_id
          score.marks            = details[:marks]
          score.grading_level_id = details[:grading_level_id]
          score.remarks          = details[:remarks]
        end
      else
        @homework_score.update_attributes(details)
      end
    end
    flash[:notice] = 'homework scores updated.'
    redirect_to [@homework_group, @homework]
  end

  private
  def query_data
    @homework_group = HomeworkGroup.find(params[:homework_group_id], :include => :batch)
    @batch = @homework_group.batch
    @course = @batch.course
  end

end
