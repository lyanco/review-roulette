require "test_helper"

class UserEntryTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:lee)
  end

  def teardown
    Warden.test_reset!
  end

  test 'should be able to create an entry' do
    login_as @user
    get root_path
    assert_select 'a', text: 'Post Entry'
    get new_entry_path
    content = "hey there whats up man!"
    assert_difference 'Entry.count', 1 do
      post entries_path, entry: { content: content }
    end
    entry = assigns(:entry)
    assert_redirected_to entry
    follow_redirect!
    assert_match content, response.body
    assert_not flash.empty?

  end


end
