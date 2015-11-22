class RemindWorker
  include Sidekiq::Worker

  def perform(reminder_id)
    reminder = Reminder.find(reminder_id)
    return if reminder.appointment_cancelled?
    AppointmentReminder.new(reminder).perform
  end

end