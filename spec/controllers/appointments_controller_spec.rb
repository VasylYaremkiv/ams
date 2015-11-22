require 'rails_helper'


describe AppointmentsController do

  include Devise::TestHelpers

  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end


  describe 'GET #index' do
    it 'populates an array of appointments' do
      appointment = FactoryGirl.create(:appointment, user: @user)
      get :index
      expect(assigns(:appointments)).to include(appointment)
    end

    it 'renders the :index view' do
      get :index
      expect(response).to render_template('index')
    end
  end

  describe 'POST #create' do

    context 'valid' do

      let(:appointment_start_time) { 2.days.from_now.beginning_of_day + 10.hours }
      subject { post :create, :appointment => appointment_params(appointment_start_time) }

      it 'create a new appointment' do
        expect{subject}.to change{ Appointment.count }.by(1)
      end

      it 'create reminders' do
        expect{subject}.to change{ Reminder.count }.by(2)
      end

      it 'create reminder workers' do
        expect{subject}.to change{ RemindWorker.jobs.count }.by(2)
      end

      it "redirects_to appointments" do
        expect(subject).to redirect_to(appointments_path)
      end

    end

    context 'invalid past time' do

      let(:appointment_start_time) { 10.minutes.ago }
      subject { post :create, :appointment => appointment_params(appointment_start_time) }

      it 'does not create a new appointment' do
        expect{subject}.to change{ Appointment.count }.by(0)
      end

      it 'does not create reminders' do
        expect{subject}.to change{ Reminder.count }.by(0)
      end

      it "render new view" do
        expect(subject).to render_template(:new)
      end

    end
  end


  private

  def appointment_params(appointment_start_time)
    {
        description: 'test',
        start_at: appointment_start_time,
        reminders_attributes: [ { remind_at: appointment_start_time - 1.hours, description: 'Text'},
                                { remind_at: appointment_start_time - 2.hours, description: 'Text'} ]
    }
  end


end


