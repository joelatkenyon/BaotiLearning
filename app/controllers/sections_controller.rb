class SectionsController < ApplicationController
  before_action :require_instructor!

  def create
    @course = Course.find(params[:course_id])
    @section = @course.sections.create(section_params)
    redirect_to course_path(@course)
  end

  private
    def section_params
      params.require(:section).permit(:title)
    end

    def require_instructor!
        @course = Course.find(params[:course_id])
        unless @course.check_user_role(current_user) == "instructor"
            flash[:error] = "You must be an instructor of this course to continue."
            redirect_to course_path(@course)
        end
    end
end
