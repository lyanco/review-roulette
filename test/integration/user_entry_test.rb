require 'test_helper'

class UserEntryTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:lee)
    @entry = entries(:entry1)
    @notleeentry = entries(:entry2)
  end

  def teardown
    Warden.test_reset!
  end

  test 'should be able to create an entry' do
    login_as @user
    get root_path
    assert_select 'a', text: 'Post Entry'
    get new_entry_path
    content = 'hey there whats up man!'
    assert_difference 'Entry.count', 1 do
      post entries_path, entry: { content: content }
    end
    entry = assigns(:entry)
    assert_redirected_to entry
    follow_redirect!
    assert_match content, response.body
    assert_not flash.empty?
  end

  test 'should be able to view an entry from a list' do
    login_as @user
    get root_path
    assert_select 'a', text: 'My Entries'

    content = 'hey there whats up man!'
    post entries_path, entry: { content: content }

    get entries_path
    puts response.body
    @user.entries.each do |entry|
      assert_select 'a[href=?]', entry_path(entry)
    end
    assert_select 'a[href=?]', entry_path(@notleeentry), count: 0


  end


end