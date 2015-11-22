class CreateReminders < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
      t.integer :appointment_id, null: false
      t.datetime :remind_at, null: false
      t.string :status, default: Reminder::PENDING
      t.text :description

      t.timestamps null: false
    end

    add_index :reminders, :appointment_id

  end
end
