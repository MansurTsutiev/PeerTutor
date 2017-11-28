class CreateCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :courses do |t|
      t.references :subject, foreign_key: true
      t.string :number
      t.string :name

      t.timestamps
    end
  end
end
