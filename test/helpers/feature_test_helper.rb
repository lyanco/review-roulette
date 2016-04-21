module FeatureTestHelper
  def user_logs_in
    visit root_path
    click_link('Sign in')
    fill_in('Email', with: 'lee@example.com')
    fill_in('Password', with: 'password')
    click_button('Log in')
  end
end