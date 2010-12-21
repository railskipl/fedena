class HomeworkGroupsController < ApplicationController
  before_filter :initial_queries
  filter_access_to :all
  in_place_edit_for :homework_group, :name

  in_place_edit_for :homework, :maximum_marks
  in_place_edit_for :homework, :minimum_marks
  in_place_edit_for :homework, :weightage

  def index
    @homework_groups = @batch.homework_groups
  end

  def new

  end

  def create
   
    @homework_group = HomeworkGroup.new(params[:homework_group])
    @homework_group.batch_id = @batch.id
    if @homework_group.save
      flash[:notice] = 'homework group created successfully.'
      redirect_to batch_homework_groups_path(@batch)
    else
      render 'new'
    end
  end

  def edit
    @homework_group = HomeworkGroup.find params[:id]
  end

  def update
    @homework_group = HomeworkGroup.find params[:id]
    if @homework_group.update_attributes(params[:homework_group])
      flash[:notice] = 'Updated homework group successfully.'
      redirect_to [@batch, @homework_group]
    else
      render 'edit'
    end
  end

  def destroy
    @homework_group = HomeworkGroup.find(params[:id])
    @homework_group.destroy
    redirect_to [@batch, @homework_groups]
  end

  def show
    @homework_group = HomeworkGroup.find(params[:id], :include => :homeworks)
  end

  private
  def initial_queries
    @batch = Batch.find params[:batch_id], :include => :course unless params[:batch_id].nil?
    @course = @batch.course unless @batch.nil?
  end

end