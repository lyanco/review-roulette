require "test_helper"
require "nokogiri"
include Devise::TestHelpers
include Warden::Test::Helpers
Warden.test_mode!

class SignInSignOutTest < Capybara::Rails::TestCase

  def teardown
    Warden.test_reset!
  end

  test 'sign in and sign out' do
    #layout should include name and email
    visit new_user_registration_path
    assert_content page, "Email"
    assert_content page, "Password"
    assert_content page, "Password confirmation"
    #When I input bad information
    fill_in('Email', with: 'test@example.com')
    fill_in('Password', with: 'ssssss')
    fill_in('Password confirmation', with: 'abcdefgh')
    click_link_or_button('Sign up')
    #Then the signup should render again
    assert current_path, new_user_registration_path
    #When I enter good information
    fill_in('Email', with: 'test@example.com')
    fill_in('Password', with: 'abcdefgh')
    fill_in('Password confirmation', with: 'abcdefgh')
    click_link_or_button('Sign up')
    #Then I should be signed up
    assert_content page, "Welcome! You have signed up successfully."

  end

end