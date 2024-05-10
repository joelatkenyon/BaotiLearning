class Course < ApplicationRecord
    # Has many enrollments, which allows it to have many users; enrollments
    # are destroyed if the course is destroyed
    # Many-many relationship in the database
    has_many :enrollments
    has_many :users, :through => :enrollments, dependent: :destroy
    # One course has many sections, which are destroyed if course is destroyed
    # One-many relationship in the database
    has_many :sections, dependent: :destroy
    
    # Require all fields to be filled out to prevent empty courses
    validates :title, presence: true
    validates :description, presence: true
    # Price cannot be negative
    validates :price, presence: true, comparison: {greater_than_or_equal_to: 0}
    # Course should start after the current date and time
    validates :start_date, presence: true, comparison: {greater_than: DateTime.current}
    # Course should end after it starts
    validates :end_date, presence: true, comparison: {greater_than: :start_date}

    # Add a new course enrollment for user new_user with new_role
    def add_user(new_user, new_role)
        self.enrollments.create(user: new_user, role: new_role)
    end

    # Returns the role of the checked_user for the given course
    def check_user_role(checked_user)
        unless checked_user == nil
            return self.enrollments.where(user_id: checked_user.id).pick(:role)
        else
            return nil
        end
    end
end
