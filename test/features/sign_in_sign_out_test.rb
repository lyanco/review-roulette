require "test_helper"
require "nokogiri"

class SignInSignOutTest < Capybara::Rails::TestCase

  def setup
    logout
  end

  def teardown
    Warden.test_reset!
  end

  test 'sign in and sign out' do
    #Given it is my first time to the page
    visit root_path
    #When I sign up
    click_link('Sign up')
    #Then I should see the sign up form
    assert_content page, "Email"
    assert_content page, "Password"
    assert_content page, "Password confirmation"
    #When I input bad information
    fill_in('Email', with: 'test@example.com')
    fill_in('Password', with: 'ssssss')
    fill_in('Password confirmation', with: 'abcdefgh')
    click_button('Sign up')
    #Then the signup should render again
    assert current_path, new_user_registration_path
    #When I enter good information
    fill_in('Email', with: 'test@example.com')
    fill_in('Password', with: 'abcdefgh')
    fill_in('Password confirmation', with: 'abcdefgh')
    click_button('Sign up')
    #Then I should be signed up
    assert_content page, "Welcome! You have signed up successfully."
    #When I click sign out
    click_link('Sign out')
    #Then I should be signed out
    assert_content page, 'Signed out successfully.'
    assert_no_content page, 'Sign out'
    #When I click sign in
    click_link('Sign in')
    #And enter my credentials
    fill_in('Email', with: 'test@example.com')
    fill_in('Password', with: 'abcdefgh')
    click_button('Log in')
    #Then I should be signed in
    assert_content page, 'Signed in successfully.'
  end


end