require "test_helper"
include Devise::TestHelpers
include Warden::Test::Helpers
Warden.test_mode!

class SignInTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:lee)
  end

  def teardown
    Warden.test_reset!
  end


end
