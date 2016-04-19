require 'test_helper'

class UserEntryTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:lee)
    @notlee = users(:notlee)
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
    @user.entries.each do |entry|
      assert_select 'a[href=?]', entry_path(entry)
    end
    assert_select 'a[href=?]', entry_path(@notleeentry), count: 0
  end

  test 'should be able to edit your own entry and not others' do
    login_as @user
    get entries_path

    @user.entries.each do |entry|
      assert_select 'a[href=?]', edit_entry_path(entry)
    end
    assert_select 'a[href=?]', edit_entry_path(@notleeentry), count: 0

    get entry_path(@entry)
    assert_select 'a[href=?]', edit_entry_path(@entry)
    get edit_entry_path(@entry)
    content = 'this is edited content'
    patch entry_path(@entry), entry: { content: content }
    assert_redirected_to @entry
    follow_redirect!
    assert_match content, response.body

    get edit_entry_path(@notleeentry)
    patch entry_path(@notleeentry), entry: { content: content }
    assert_not_equal @notleeentry.content, content

  end

  test 'should be able to access and index others entries' do
    login_as @user
    get entries_path
    assert_select 'a[href=?]', entry_path(@notleeentry), count: 0
    get entries_path, user_id: @notlee.id
    assert_select 'a[href=?]', entry_path(@notleeentry)
    assert_select 'a[href=?]', entry_path(@entry), count: 0
    assert_select 'a[href=?]', edit_entry_path(@notleeentry), count: 0
    get entry_path(@notleeentry)
    assert_template 'entries/show'
    assert_match @notleeentry.content, response.body
  end


end
