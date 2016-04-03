require 'test_helper'
include Devise::TestHelpers
include Warden::Test::Helpers
Warden.test_mode!

class UserTest < ActiveSupport::TestCase

  test "should be valid" do
    assert @user.valid?
  end

  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end

end
