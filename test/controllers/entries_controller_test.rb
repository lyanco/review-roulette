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

  test 'should get index when logged in' do
    sign_in @user
    get :index
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

  test 'should be able to create an entry by posting with my password token' do
    assert_difference 'Entry.count', 1 do
      post :create_api, entry: { content: 'Lorem Ipsum', api_data: {
          user_id: @user.id, auth_token: @user.encrypted_password} }, format: 'json'
    end
    assert_equal 'Lorem Ipsum', JSON.parse(response.body)['content']
  end

  #TODO: uncomment when there are more validations on an entry
  #test 'should not be able to create an entry posting via JSON when entry is invalid' do
  #  assert_difference 'Entry.count', 1 do
  #    post :create_api, entry: { content: nil, api_data: {
  #        user_id: @user.id, auth_token: @user.encrypted_password} }, format: 'json'
  #  end
  #  puts JSON.parse(response.body)
  #end

  test 'should not be able to create an entry when posting HTML with my password token' do
    assert_raises ActionController::UnknownFormat do
      post :create_api, entry: { content: 'Lorem Ipsum', api_data: {
          user_id: @user.id, auth_token: @user.encrypted_password} }, format: 'html'
    end
  end

  test 'should not be able to create an entry when posting with a nil user id or pw' do
    assert_no_difference 'Entry.count' do
      post :create_api, entry: { content: 'Lorem Ipsum', api_data: {
          user_id: nil, auth_token: @user.encrypted_password} }, format: 'json'
    end
    assert_equal 'unprocessable_entity', JSON.parse(response.body)['status']
    assert_no_difference 'Entry.count' do
      post :create_api, entry: { content: 'Lorem Ipsum', api_data: {
          auth_token: @user.encrypted_password} }, format: 'json'
    end
    assert_equal 'unprocessable_entity', JSON.parse(response.body)['status']
    assert_no_difference 'Entry.count' do
      post :create_api, entry: { content: 'Lorem Ipsum', api_data: {
          user_id: @user.id, auth_token: nil} }, format: 'json'
    end
    assert_equal 'unprocessable_entity', JSON.parse(response.body)['status']
    assert_no_difference 'Entry.count' do
      post :create_api, entry: { content: 'Lorem Ipsum', api_data: {
          user_id: @user.id } }, format: 'json'
    end
    assert_equal 'unprocessable_entity', JSON.parse(response.body)['status']
    assert_no_difference 'Entry.count' do
      post :create_api, entry: { content: 'Lorem Ipsum', api_data: {
          } }, format: 'json'
    end
    assert_equal 'unprocessable_entity', JSON.parse(response.body)['status']
    assert_no_difference 'Entry.count' do
      post :create_api, entry: { content: 'Lorem Ipsum', api_data: {
          user_id: nil, auth_token: nil } }, format: 'json'
    end
    assert_equal 'unprocessable_entity', JSON.parse(response.body)['status']
  end

  test 'should not be able to create an entry when posting with an invalid password token' do
    assert_no_difference 'Entry.count' do
      post :create_api, entry: { content: 'Lorem Ipsum', api_data: {
          user_id: @user.id, auth_token: 'garbage' } }, format: 'json'
    end
    assert_equal 'unprocessable_entity', JSON.parse(response.body)['status']
  end

  test 'should not be able to create an entry when posting with a nonexistent user' do
    assert_no_difference 'Entry.count' do
      post :create_api, entry: { content: 'Lorem Ipsum', api_data: {
          user_id: 0, auth_token: @user.encrypted_password } }, format: 'json'
    end
    assert_equal 'unprocessable_entity', JSON.parse(response.body)['status']
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
