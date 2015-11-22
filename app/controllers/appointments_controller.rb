class AppointmentsController < ApplicationController

  before_action :authenticate_user!
  before_action :load_appointment, only: %w(edit update)

  def index
    @appointments = current_user.appointments.incoming.filter_by_status(params[:status])
  end

  def past
    @appointments = current_user.appointments.past.filter_by_status(params[:status])
  end

  def new
    @appointment = Appointment.new
  end

  def create
    @appointment = current_user.appointments.new(appointment_params)
    if @appointment.save
      redirect_to appointments_path
    else
      render :new
    end
  end

  def edit
    render
  end

  def update
    if @appointment.update(appointment_edit_params)
      redirect_to appointments_path
    else
      render :edit
    end
  end

  private

  def appointment_params
    params.require(:appointment).permit(:description, :start_at, reminders_attributes: [:remind_at, :description])
  end

  def load_appointment
    @appointment = current_user.appointments.find(params[:id])
  end

  def appointment_edit_params
    params.require(:appointment).permit(:status)
  end


end