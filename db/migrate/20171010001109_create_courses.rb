class CreateCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :courses do |t|
      t.integer :subject_id
      t.string :number
      t.string :name

      t.timestamps
    end
  end
end
