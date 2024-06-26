class SectionsController < ApplicationController
  # Prevent manipulating sections unless you are an instructor
  before_action :require_instructor!

  def create
    @course = Course.find(params[:course_id])
    @section = @course.sections.create(section_params)
    redirect_to course_path(@course)
  end

  def destroy
    @course = Course.find(params[:course_id])
    @section = @course.sections.find(params[:id])
    @section.destroy
    redirect_to course_path(@course), status: :see_other
  end

  private
    def section_params
      params.require(:section).permit(:title)
    end

    # Makes sure that the current user is an instructor
    # of the course to which the section belongs
    def require_instructor!
        @course = Course.find(params[:course_id])
        unless @course.check_user_role(current_user) == "instructor"
            flash[:error] = "You must be an instructor of this course to continue."
            redirect_to course_path(@course)
        end
    end
end
