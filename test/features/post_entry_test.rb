require "test_helper"
require "nokogiri"

class PostEntryTest < Capybara::Rails::TestCase

  def setup
    logout
  end

  def teardown
    Warden.test_reset!
  end

  test 'post my entry' do
    #Given I am logged in
    visit root_path
    click_link('Sign in')
    fill_in('Email', with: 'lee@example.com')
    fill_in('Password', with: 'password')
    click_button('Log in')

    #And am on the home page
    #puts page.body
    assert_content page, 'Post Entry'
    visit root_path
    #When I click the Post Entry button
    click_link('Post Entry')
    #Then I should see a form for an entry
    assert_content page, 'Your Entry'
    #When I input my entry
    fill_in('Your Entry', with: 'hi this is my entry!!!')
    click_button('Create Entry')
    #Then I should see my entry
    assert_content page, 'hi this is my entry!!!'
  end


end
