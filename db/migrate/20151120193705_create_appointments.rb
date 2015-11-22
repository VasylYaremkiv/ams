class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.integer :user_id, null: false
      t.datetime :start_at, null: false
      t.string :status, default: Appointment::PENDING
      t.text :description

      t.timestamps null: false
    end

    add_index :appointments, :user_id

  end
end
