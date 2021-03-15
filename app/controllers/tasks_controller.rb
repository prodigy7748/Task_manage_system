class TasksController < ApplicationController
  before_action :find_task, only:[:edit, :update, :destroy, :show]

  def index
    @tasks = Task.all
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to tasks_path, notice: t('.notice')
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: t('.notice')
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to root_path, notice: t('.notice')
  end

  private
  def task_params
    params.require(:task).permit(:title, :content, :start_time, :end_time)
  end

  def find_task
    @task = Task.find(params[:id])
  end
end
