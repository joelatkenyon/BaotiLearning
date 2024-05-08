class AssignmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_enrolled!
  before_action :require_instructor_on_page!, only: [:edit, :update, :destroy]
  before_action :require_instructor_off_page!, only: [:new, :create]

  def show
    @course = Course.find(params[:course_id])
    @section = @course.sections.find(params[:section_id])
    @assignment = @section.assignments.find(params[:id])
  end

  def new
    @course = Course.find(params[:course_id])
    @section = @course.sections.find(params[:section_id])
  end

  def create
    @course = Course.find(params[:course_id])
    @section = @course.sections.find(params[:section_id])
    @assignment = @section.assignments.create(assignment_params)
    redirect_to course_path(@course)
  end

  def edit
    @course = Course.find(params[:course_id])
    @section = @course.sections.find(params[:section_id])
    @assignment = @section.assignments.find(params[:id])
  end

  def update
    @course = Course.find(params[:course_id])
    @section = @course.sections.find(params[:section_id])
    @assignment = @section.assignments.find(params[:id])
    if @assignment.update(assignment_params)
      redirect_to course_section_assignment_path(:course_id => @course.id, :section_id => @section.id)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @course = Course.find(params[:course_id])
    @section = @course.sections.find(params[:section_id])
    @assignment = @section.assignments.find(params[:id])
    @assignment.destroy
    redirect_to course_path(@course), status: :see_other
  end

  private
    def assignment_params
      params.require(:assignment).permit(:title, :description, :opendate, :closedate)
    end

    def require_enrolled!
      @course = Course.find(params[:course_id])
      if @course.check_user_role(current_user) == nil
        flash[:error] = "You must be enrolled in this course to continue."
        redirect_to course_path(@course)
      end
    end

    def require_instructor_on_page!
      @course = Course.find(params[:course_id])
      @section = @course.sections.find(params[:section_id])
      @assignment = @section.assignments.find(params[:id])
      unless @course.check_user_role(current_user) == "instructor"
        flash[:error] = "You must be an instructor of this course to continue."
        redirect_to course_section_assignment_path(:course_id => @course.id, :section_id => @section.id)
      end
    end

    def require_instructor_off_page!
      @course = Course.find(params[:course_id])
      unless @course.check_user_role(current_user) == "instructor"
        flash[:error] = "You must be an instructor of this course to continue."
        redirect_to course_path(@course)
      end
    end
end
