require "test_helper"

class SignInTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:lee)
  end

  def teardown
    Warden.test_reset!
  end

  test 'not-logged-in user shouldnt see logged-in links' do
    get root_path
    assert_no_match 'Post Entry', response.body
    assert_no_match 'My Entries', response.body
  end

end
