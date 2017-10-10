class CreateTutoringSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :tutoring_sessions do |t|
      t.integer :user_id
      t.integer :tutor_id
      t.integer :course_id
      t.string :question

      t.timestamps
    end
  end
end
