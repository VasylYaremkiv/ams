class Appointment < ActiveRecord::Base

  PENDING = 'pending'
  CONFIRMED = 'confirmed'
  CANCELLED = 'cancelled'
  DURATION = 1.hours
  AVAILABLE_STATUSES = [PENDING, CONFIRMED, CANCELLED]

  belongs_to :user
  has_many :reminders, inverse_of: :appointment
  accepts_nested_attributes_for :reminders

  scope :incoming, -> { where('start_at > ?', Time.current).includes(:reminders).order(:start_at) }
  scope :past, -> { where('start_at < ?', Time.current).includes(:reminders).order(start_at: :desc) }
  scope :filter_by_status, -> status do
    where(status: status) if AVAILABLE_STATUSES.include?(status)
  end
  scope :filter_by_date, -> date do
    if parsed_date = date && Date.parse(date)
      where(start_at: parsed_date..parsed_date + 1.day)
    end
  end

  validates :user, :start_at, presence: true
  before_validation :has_valid_start_time?, on: :create

  def cancelled?
    status == CANCELLED
  end

  def to_builder
    Jbuilder.new do |appointment|
      appointment.(self, :id, :status, :description, :start_at)
    end
  end

  private

  def has_valid_start_time?
    return if start_at.blank?

    errors.add(:start_at, :passed) if start_at.past?
    if Appointment.where.not(id: id).where(start_at: start_at - DURATION..start_at + DURATION, user: user).exists?
      errors.add(:start_at, :overlap)
    end
  end

end
