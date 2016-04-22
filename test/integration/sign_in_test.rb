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
    assert_select 'a', text: 'Post Entry', count: 0
    assert_select 'a', text: 'My Entries', count: 0
    assert_select 'a', text: 'Other Entries', count: 0
    assert_select 'a', text: 'Profile', count: 0
    assert_select 'a', text: 'Sign out', count: 0
    assert_select 'a', text: 'Sign in'
    assert_select 'a', text: 'Sign up'

    get page_path('about')

    login_as @user
    get root_path

    assert_select 'a', text: 'Post Entry'
    assert_select 'a', text: 'My Entries'
    assert_select 'a', text: 'Other Entries'
    assert_select 'a', text: 'Profile'
    assert_select 'a', text: 'Sign out'
    assert_select 'a', text: 'Sign in', count: 0
    assert_select 'a', text: 'Sign up', count: 0
  end

end
