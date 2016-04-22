require "test_helper"

class UsersControllerTest < ActionController::TestCase

  def setup
    @user = users(:lee)
    @notlee = users(:notlee)
  end

  test 'should respond get' do
    sign_in @user
    get :show, id: @user
    assert_response :success
  end

  test 'should fail on getting another profile' do
    sign_in @user
    get :show, id: @notlee
    assert_response :redirect
  end

  test 'should fail when not logged in' do
    assert_raises(NoMethodError) { get :show, id: @user }
  end

end
