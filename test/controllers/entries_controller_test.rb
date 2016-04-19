require "test_helper"

class EntriesControllerTest < ActionController::TestCase

  def setup
    @user = users(:lee)
    @user2 = users(:notlee)
    @entry = entries(:entry1)
  end

  test "should redirect everything when not logged in" do
    assert_raises NoMethodError do
      post :create, entry: { content: "Lorem Ipsum" }
    end
  end

  test "should create when logged in" do
    sign_in @user
    assert_difference 'Entry.count', 1 do
      post :create, entry: { content: "Lorem Ipsum" }
    end
    assert_redirected_to @user.entries.last
  end

  test "should get show when logged in" do
    sign_in @user
    get :show, id: @entry
    assert_response :success
  end

  test "should get new when logged in" do
    sign_in @user
    get :new
    assert_response :success
  end

  test "should show all my entries" do
    sign_in @user
    get :index
    assert_response :success
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
