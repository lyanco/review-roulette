require "test_helper"
include Devise::TestHelpers
include Warden::Test::Helpers
Warden.test_mode!

class SignInTest < ActionDispatch::IntegrationTest
  def test_sanity
    #flunk "Need real tests"
  end
end
