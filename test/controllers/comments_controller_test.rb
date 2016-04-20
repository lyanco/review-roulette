require 'test_helper'

class CommentsControllerTest < ActionController::TestCase

  setup do
    @user = users(:lee)
    @user2 = users(:notlee)
    @entry = entries(:entry1)
    @notleeentry = entries(:entry2)
  end

  test 'should fail when not logged in' do
    assert_raises(NoMethodError) do
      post :create, comment: { content: 'hey i am a controller comment', entry_id: @notleeentry.id }
    end
  end

  test 'should create comment when logged in' do
    sign_in @user
    assert_difference 'Comment.count', 1 do
      post :create, comment: { content: 'hey i am a controller comment', entry_id: @notleeentry.id }
    end
    assert_redirected_to entry_path(assigns(:comment).entry)
    assert_equal @user.id, assigns(:comment).user_id
  end

  test 'should not be able to set user id' do
    sign_in @user
    post :create, comment: { content: 'hey i am a controller comment', entry_id: @notleeentry.id, user_id: @user2.id }
    assert_equal @user.id, assigns(:comment).user_id
  end


end
