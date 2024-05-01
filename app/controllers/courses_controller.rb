class CoursesController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
    before_action :is_instructor?, only: [:edit, :update, :destroy]

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
            @course.enrollments.create(user: current_user, role: "instructor")
            redirect_to @course
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
            redirect_to @course
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @course = Course.find(params[:id])
        @course.destroy
        redirect_to root_path, status: :see_other
    end

    private
        def course_params
            params.require(:course).permit(:title, :description, :price, :start_date, :end_date)
        end

        def is_instructor?
            @course = Course.find(params[:id])
            instructor_id_array = @course.enrollments.where(role: "instructor").pluck(:user_id)
            unless instructor_id_array.include? current_user.id
                flash[:error] = "You must be an instructor of this course to proceed."
                redirect_to @course
            end
        end
end