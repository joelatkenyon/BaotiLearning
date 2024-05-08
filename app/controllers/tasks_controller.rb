class TasksController < ApplicationController
  before_action :set_user_task, only: [:index, :new, :create]
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @pending_tasks = @user.tasks.where(status: "Pending")
    @completed_tasks = @user.tasks.where(status: "Completed")
  end

  def new
    @task = @user.tasks.build
  end

  def create
    @task = @user.tasks.build(task_params)
    @task.status = "Pending"
    if @task.save
      @task.bucket.update_status
      redirect_to task_path(@task)
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
      @task.bucket.update_status
      redirect_to task_path(@task)
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path
  end

  private
    def set_user_task
      @user = User.find(params[:user_id])
    end

    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:name, :description, :status, :bucket_id)
    end
end
