require "test_helper"
require "nokogiri"

class PostEntryTest < Capybara::Rails::TestCase

  def setup
    logout
  end

  def teardown
    Warden.test_reset!
  end

  test 'post and view a comment' do
    #Given I am logged in
    visit root_path
    click_link('Sign in')
    fill_in('Email', with: 'lee@example.com')
    fill_in('Password', with: 'password')
    click_button('Log in')

    #When I navigate to another persons entry
    click_link('Other Entries')
    find('a', text: 'View', match: :first).click
    #And fill in a comment
    comment = 'this is a commentous comment'
    fill_in('Your Comment', with: comment)
    click_button('Create Comment')
    #Then I should see my comment
    assert_content page, comment



  end


end
