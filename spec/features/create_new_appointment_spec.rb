require 'rails_helper'

feature 'Create appointment' do

  scenario 'with valid params' do
    user  = FactoryGirl.create(:user)
    sign_up_with user.email, '12345678'
    click_link('New appointment')
    fill_in 'Description', with: 'My Appointment'
    select_date_and_time(2.days.from_now.beginning_of_day + 10.hours, from: 'appointment_start_at')
    click_button('Create')
    expect(page).to have_text('My Appointment')
    expect(page).to_not have_button('Create')

  end

  scenario 'with invalid start time' do
    user  = FactoryGirl.create(:user)
    sign_up_with user.email, '12345678'
    click_link('New appointment')
    fill_in 'Description', with: 'My Appointment'
    select_date_and_time(2.days.ago.beginning_of_day + 10.hours, from: 'appointment_start_at')
    click_button('Create')
    expect(page).to have_current_path(appointments_path)
    expect(page).to have_text('My Appointment')
    expect(page).to have_text('Start at is passed.')
    expect(page).to have_button('Create')
  end

  def select_date_and_time(date, options = {})
    field = options[:from]
    select date.strftime('%Y'),  :from => "#{field}_1i"
    select date.strftime('%B'),  :from => "#{field}_2i"
    select date.strftime('%-d'), :from => "#{field}_3i"
    select date.strftime('%I %P').upcase,  :from => "#{field}_4i"
    select date.strftime('%M'),  :from => "#{field}_5i"
  end

end