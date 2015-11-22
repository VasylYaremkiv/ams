class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  CUSTOMER = 'customer'
  ADMIN = 'admin'

  has_many :appointments
  has_many :user_statistics

  before_create :generate_token

  def admin?
    role == ADMIN
  end

  private

  def generate_token
    charset = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
    charset_length = charset.length
    self.token ||= loop do
      token = 20.times.inject('') { |s| s << charset[rand(charset_length)] }
      break token unless User.exists?(token: token)
    end
  end

end

