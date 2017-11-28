class CreateTutors < ActiveRecord::Migration[5.1]
  def change
    create_table :tutors do |t|
     t.references :user, foreign_key: true
     ##tracks tutor if available
     t.boolean :is_live, default: false
     ##amount earned in tips
     t.decimal :total_tip, scale: 2, precision: 10
     t.timestamps
    end
  end
end
