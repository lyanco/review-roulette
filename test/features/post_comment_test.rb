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
    user_logs_in

    #When I navigate to another persons entry
    click_link('Other Entries')
    find('a', text: 'View', match: :first).click
    #And fill in a comment
    comment = 'this is a commentous comment'
    fill_in('Your Comment', with: comment)
    click_button('Create Comment')
    #Then I should see my comment
    assert_content page, comment

    #When I navigate to my own entry
    click_link('My Entries')
    find('a', text: 'View', match: :first).click
    #Then I should not see a form to enter comments
    assert_no_content page, 'Your Comment'
    assert_not page.has_button?('Create Comment')

  end


end
