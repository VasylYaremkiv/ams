class Api::AppointmentsController < ApplicationController

  before_action :authenticate_user_using_x_auth_token!
  before_action :generate_user_statistic

  def index
    @appointments = @user.appointments.incoming.filter_by_status(params[:status])
    render json: { appointments: @appointments.map{ |a| appointment_to_json(a) } }
  end

  def by_date
    @appointments = @user.appointments.past.filter_by_status(params[:status]).filter_by_date(params[:date])
    render json: { appointments: @appointments.map{ |a| appointment_to_json(a) } }
  end

  def create
    @appointment = @user.appointments.new(appointment_params)
    if @appointment.save
      render json: { appointment: appointment_to_json(@appointment) }
    else
      respond_with_error "Cannot create appointment: #{@appointment.errors.full_messages}", :error
    end
  end

  private

  def appointment_params
    params.require(:appointment).permit(:description, :start_at, reminders_attributes: [:remind_at, :description])
  end

  def respond_with_error(message, status)
    render json: { error: message }, status: status
  end

  def authenticate_user_using_x_auth_token!
    token = request.headers['X-Auth-Token']
         p "TOKEN: #{token}"
    @user = token && User.find_by_token(token)

    if @user
      sign_in @user, store: false
    else
      respond_with_error('Could not authenticate with the provided credentials.', :unauthorized)
    end
  end

  def appointment_to_json(appointment)
    appointment.to_builder.target!
  end

  def generate_user_statistic
    @user.user_statistics.create(params: params, api_method: action_name)
  end

end