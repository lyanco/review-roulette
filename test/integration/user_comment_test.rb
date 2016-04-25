require 'test_helper'

class UserCommentTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:lee)
    @notlee = users(:notlee)
    @entry = entries(:entry1)
    @notleeentry = entries(:entry2)
    @entry2comment1 = comments(:entry2comment1)
  end

  def teardown
    Warden.test_reset!
  end

  test 'should be able to create a comment' do
    login_as(@user)
    get entry_path(@notleeentry)
    assert_match @entry2comment1.content, response.body
    assert_select 'button', value: 'Create Comment'
    content = 'I am an integrationous comment'
    assert_difference 'Comment.count', 1 do
      post comments_path, comment: { content: content, entry_id: @notleeentry.id }
    end
    assert_redirected_to entry_path(@notleeentry)
    follow_redirect!
    assert_match content, response.body

    assert_no_difference 'Comment.count' do
      post comments_path, comment: { content: '     ', entry_id: @notleeentry.id }
    end
    assert_template 'entries/show'
    assert_match 'can&#39;t be blank', response.body
  end

  test 'should not be able to post comments on my own entry' do
    login_as(@user)
    get entry_path(@entry)
    assert_select 'button[value="Create Comment"]', count: 0
    content = 'I should fail because Im posting on my own entry'
    assert_no_difference 'Comment.count' do
      post comments_path, comment: { content: content, entry_id: @entry.id }
    end
  end

  test 'should see a random entry on the home page' do
    login_as(@user)
    get root_url
    #assert_match 'Give a review to', response.body
  end


end
