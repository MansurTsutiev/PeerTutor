class CreateTutorProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :tutor_profiles do |t|
      ##Major of the specified tutor
      t.string :major, null: false , default: ''
      ##tracks tutor if available
      t.boolean :is_live, default: false
      ##amount earned in tips
      t.decimal :total_tip, scale: 2, precision: 10



      t.timestamps
    end
  end
end
