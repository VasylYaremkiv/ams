class Reminder < ActiveRecord::Base
  PENDING = 'pending'
  REMINDED = 'reminded'

  belongs_to :appointment, inverse_of: :reminders

  validates :appointment, :remind_at, presence: true

  before_validation :has_valid_start_time?, on: :create
  after_create :generate_remind_worker

  delegate :cancelled?, to: :appointment, prefix: true

  private

  def has_valid_start_time?
    return if remind_at.blank?

    errors.add(:remind_at, :passed) if remind_at.past?
    errors.add(:remind_at, :too_later) if appointment && appointment.start_at < remind_at
  end

  def generate_remind_worker
    RemindWorker.perform_at(remind_at, id)
  end

end
