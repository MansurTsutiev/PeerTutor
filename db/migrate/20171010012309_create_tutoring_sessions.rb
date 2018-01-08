class CreateTutoringSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :tutoring_sessions do |t|
      t.references :user, index: { unique: true }, foreign_key: { to_table: :users }
      t.references :tutor, foreign_key: { to_table: :users }
      t.references :course, foreign_key: true
      t.string :question

      t.timestamps
    end
  end
end
