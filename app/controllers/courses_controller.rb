class CoursesController < ApplicationController
    # Require login to do anything other than view list of courses and
    # to see the basic overview of the course, i.e. no sections
    before_action :authenticate_user!, except: [:index, :show]
    # Require instructor of course to edit or destroy the course
    before_action :require_instructor!, only: [:edit, :update, :destroy]
    # Prevent enrolled people from enrolling again
    # and creating a duplicate enrollment
    before_action :require_unenrolled!, only: [:enroll]
    # Prevent enrollment after the course has started
    before_action :require_has_not_started!, only: [:enroll]

    def index
        @courses = Course.all
    end

    def show
        @course = Course.find(params[:id])
    end

    def new
        @course = Course.new
    end

    def create
        @course = Course.new(course_params)
        if @course.save
            @course.add_user(current_user, "instructor")
            redirect_to course_path(@course)
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
        @course = Course.find(params[:id])
    end

    def update
        @course = Course.find(params[:id])
        if @course.update(course_params)
            redirect_to course_path(@course)
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @course = Course.find(params[:id])
        @course.destroy
        redirect_to root_path, status: :see_other
    end

    def enroll
        @course = Course.find(params[:id])
        @course.add_user(current_user, "student")
        redirect_to course_path(@course)
    end

    private
        def course_params
            params.require(:course).permit(:title, :description, :price, :start_date, :end_date)
        end

        # Makes sure that the course has not started, i.e. that the
        # current date and time is before the course start date and time
        def require_has_not_started!
            @course = Course.find(params[:id])
            unless @course.start_date > DateTime.current
                flash[:error] = "You cannot enroll in a course that has already started."
                redirect_to course_path(@course)
            end
        end

        # Makes sure that the current user is an instructor of the course
        def require_instructor!
            @course = Course.find(params[:id])
            unless @course.check_user_role(current_user) == "instructor"
                flash[:error] = "You must be an instructor of this course to continue."
                redirect_to course_path(@course)
            end
        end

        # Makes sure that the current user is not enrolled in the course
        def require_unenrolled!
            @course = Course.find(params[:id])
            unless @course.check_user_role(current_user) == nil
                flash[:error] = "You are already enrolled in this course."
                redirect_to course_path(@course)
            end
        end
end