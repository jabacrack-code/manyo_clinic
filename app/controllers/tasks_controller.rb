class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    # Start with all tasks
    @tasks = Task.all

    # Search filtering via scope: :search params
    if params[:search].present?
      if params[:search][:title].present? && params[:search][:status].present?
        @tasks = @tasks.search_title(params[:search][:title]).search_status(params[:search][:status])
      elsif params[:search][:title].present?
        @tasks = @tasks.search_title(params[:search][:title])
      elsif params[:search][:status].present?
        @tasks = @tasks.search_status(params[:search][:status])
      end
    end

    # Sorting: deadline, priority, or default (newest first)
    if params[:sort_deadline_on]
      @tasks = @tasks.sort_deadline_on
    elsif params[:sort_priority]
      @tasks = @tasks.sort_priority
    else
      @tasks = @tasks.sort_created_at
    end

    # Pagination
    @tasks = @tasks.page(params[:page]).per(10)
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to tasks_path, notice: t('flash.tasks.create')
    else
      render :new
    end
  end

  def update
    if @task.update(task_params)
      redirect_to @task, notice: t('flash.tasks.update')
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: t('flash.tasks.destroy')
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :content, :deadline_on, :priority, :status)
  end
end
