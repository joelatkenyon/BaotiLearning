class CoursesController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
    before_action :require_instructor!, only: [:edit, :update, :destroy]
    before_action :require_unenrolled!, only: [:enroll]

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
        if current_user.balance >= @course.price
          current_user.balance -= @course.price
          current_user.save
          redirect_to course_path(@course)
        else
          flash[:error] = "Insufficient balance to purchase this course."
        end
    end

    private
        def course_params
            params.require(:course).permit(:title, :description, :price, :start_date, :end_date)
        end

        def require_instructor!
            @course = Course.find(params[:id])
            unless @course.check_user_role(current_user) == "instructor"
                flash[:error] = "You must be an instructor of this course to continue."
                redirect_to course_path(@course)
            end
        end

        def require_unenrolled!
            @course = Course.find(params[:id])
            unless @course.check_user_role(current_user) == nil
                flash[:error] = "You are already enrolled in this course."
                redirect_to course_path(@course)
            end
        end
end
