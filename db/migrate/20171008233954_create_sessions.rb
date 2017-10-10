class CreateSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :sessions do |t|
      t.integer :user_id
      t.integer :tutor_id
      t.integer :course_id
      t.text :question
      
      t.timestamps
    end
  end
end
