require 'test_helper'

class EntriesControllerTest < ActionController::TestCase

  def setup
    @user = users(:lee)
    @user2 = users(:notlee)
    @entry = entries(:entry1)
    @notleeentry = entries(:entry2)
  end

  test 'should fail on all actions when not logged in' do
    assert_raises(NoMethodError) { get :index }
    assert_raises(NoMethodError) { get :new }
    assert_raises(NoMethodError) { get :show, id: @entry }
    assert_raises(NoMethodError) { get :edit, id: @entry }
    assert_raises(NoMethodError) do
      post :create, entry: { content: 'Lorem Ipsum' }
    end
    assert_raises(NoMethodError) do
      patch :update, id: @entry, entry: { content: 'Lorem Ipsum' }
    end
  end

  test 'should create when logged in' do
    sign_in @user
    assert_difference 'Entry.count', 1 do
      post :create, entry: { content: 'Lorem Ipsum' }
    end
    assert_redirected_to @user.entries.last
  end

  test 'should get show when logged in' do
    sign_in @user
    get :show, id: @entry
    assert_response :success
  end

  test 'should get new when logged in' do
    sign_in @user
    get :new
    assert_response :success
  end

  test 'should be able to edit my entry' do
    sign_in @user
    get :edit, id: @entry
    assert_response :success
  end

  test 'should not be able to edit others entries' do
    sign_in @user
    assert_raises Pundit::NotAuthorizedError do
      get :edit, id: @notleeentry
    end
  end

  test 'should be able to update my entry' do
    sign_in @user
    patch :update, id: @entry, entry: { content: 'hey' }
    assert_redirected_to entry_url(@entry)
    assert_not flash.empty?
    @entry.reload
    assert_equal 'hey', @entry.content
  end

  test 'should not be able to update others entries' do
    sign_in @user
    assert_raises Pundit::NotAuthorizedError do
      patch :update, id: @notleeentry, entry: { content: 'hey' }
    end
    assert flash.empty?
    assert_not_equal 'hey', @notleeentry.content, 'User should not be able to update entries made by others'
  end


=begin

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Entry.count' do
      delete :destroy, id: @entry
    end
    assert_redirected_to new_user_session_path
  end

 test "should destroy when logged in" do
    login_as @user
    assert_difference 'Entry.count', -1 do
      delete :destroy, id: @entry
    end
    assert_redirected_to root_path
  end


  test "should redirect destroy for wrong micropost" do
    login_as @user2
    assert_no_difference 'Entry.count' do
      delete :destroy, id: @user.entries.first
    end
    assert_redirected_to root_path
  end
=end

end
