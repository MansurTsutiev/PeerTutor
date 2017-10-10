class CreateTutorCourses < ActiveRecord::Migration[5.1]

##join table for tutor courses
  def change
    create_table :tutor_courses, :id ==> false do |t|
      t.integer :tutor_id
      t.integer :course_id


      end
      add_index("tutor_courses", ["tutor_id", "course_id"])
  end
end
