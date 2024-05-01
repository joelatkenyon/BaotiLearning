class CreateEnrollments < ActiveRecord::Migration[7.1]
  def change
    create_table :enrollments do |t|
      t.belongs_to :user
      t.belongs_to :course
      t.string :role
      t.timestamps
    end
  end
end
