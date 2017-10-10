class CreateSchedules < ActiveRecord::Migration[5.1]
  def change
    create_table :schedules do |t|
      t.date :start_date
      t.date :end_date
      t.time :start_time
      t.time :end_time
      ##for testing purposes might not be used
      t.time :current_time
      t.date :current_date

      t.timestamp

    end
  end
end
