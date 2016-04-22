require "test_helper"
require "nokogiri"


class BookmarkletTest < Capybara::Rails::TestCase

  def setup
    logout
  end

  def teardown
    Warden.test_reset!
  end

  test 'get my profile' do
    #Given I am logged in
    user_logs_in

    #When I click on the Profile link
    click_link('Profile')
    #Then I should see my email
    assert_content page, 'lee@example.com'
    #And I should see a bookmarklet that drags to the top of the page
    assert_content page, 'Remote Capture Entry'
  end


end
