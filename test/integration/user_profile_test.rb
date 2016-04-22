require 'test_helper'
require 'nokogiri'

class UserProfileTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:lee)
    @notlee = users(:notlee)
  end

  def teardown
    Warden.test_reset!
  end

  test 'should be able to view my profile and not others' do
    login_as @user
    get user_path(@user)
    assert_match @user.email, response.body
    assert_select 'a', text: 'Remote Capture Entry'

    bookmarklet = Nokogiri::HTML(response.body).css('#bookmarklet')

    assert_match URI::escape('var user_id = ' + @user.id.to_s), bookmarklet.attr('href')
    assert_match URI::escape('var encrypted_password = "' + @user.encrypted_password.to_s + '"'), bookmarklet.attr('href')

    get user_path(@notlee)
    assert_redirected_to root_url
  end


end
