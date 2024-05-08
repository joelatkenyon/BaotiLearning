class Course < ApplicationRecord
    has_many :enrollments
    has_many :users, :through => :enrollments, dependent: :destroy
    has_many :sections, dependent: :destroy
    
    validates :title, presence: true
    validates :description, presence: true
    validates :price, presence: true, comparison: {greater_than_or_equal_to: 0}
    validates :start_date, presence: true
    validates :end_date, presence: true, comparison: {greater_than: :start_date}

    def add_user(new_user, new_role)
        self.enrollments.create(user: new_user, role: new_role)
    end

    def check_user_role(checked_user)
        unless checked_user == nil
            return self.enrollments.where(user_id: checked_user.id).pick(:role)
        else
            return nil
        end
    end
end
