class CreateTutorCourses < ActiveRecord::Migration[5.1]
  #Join Table between Tutor and Course
  def change
    create_table :tutor_courses do |t|
      t.references :tutor, foreign_key: true
      t.references :course, foreign_key: true

      t.timestamps
    end
  end
end
