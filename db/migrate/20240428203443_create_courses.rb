class CreateCourses < ActiveRecord::Migration[7.1]
  def change
    create_table :courses do |t|
      t.string :title
      t.text :description
      t.decimal :price
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
  end
end
