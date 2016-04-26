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
    string = 'var post_url = "' + root_url + 'entries/create_api";
      var user_id = ' + @user.id.to_s + ';
      var encrypted_password = "' + @user.encrypted_password.to_s + '";'

    assert_match URI::escape(string.squish), bookmarklet.attr('href')

    get user_path(@notlee)
    assert_redirected_to root_url
  end


end
