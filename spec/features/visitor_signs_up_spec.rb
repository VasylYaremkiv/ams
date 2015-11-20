require 'rails_helper'

feature 'Visitor signs up' do

  scenario 'with valid email and password' do
    user  = FactoryGirl.create(:user)
    sign_up_with user.email, '12345678'
    expect(page).to have_button('Logout')
  end

  scenario 'with invalid email' do
    sign_up_with 'invalid_email', 'password'
    expect(page).to have_content('Log in')
  end

  scenario 'with blank password' do
    sign_up_with 'valid@example.com', ''
    expect(page).to have_content('Log in')
  end

end