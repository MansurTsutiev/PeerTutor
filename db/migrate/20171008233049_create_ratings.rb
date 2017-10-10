class CreateRatings < ActiveRecord::Migration[5.1]
  def change
    create_table :ratings do |t|
      t.integer :user_id
      t.integer :tutor_id
      t.decimal :star_count, precision: 3, scale: 1, default: 0
      t.text :comment

      t.timestamps
    end
  end
end
