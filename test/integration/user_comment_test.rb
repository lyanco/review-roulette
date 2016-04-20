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


end
