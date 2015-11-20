module Features
  module SessionHelpers
    def sign_up_with(email, password)
      visit new_user_session_path
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      click_button 'Log in'
    end

    def sign_in
      user = FactoryGirl.create(:user)
      visit new_user_session_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: '12345678'
      click_button 'Log in'
    end
  end
end