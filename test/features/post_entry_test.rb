require "test_helper"
require "nokogiri"

class PostEntryTest < Capybara::Rails::TestCase

  def setup
    logout
  end

  def teardown
    Warden.test_reset!
  end

  test 'post my entry' do
    #Given I am logged in
    visit root_path
    click_link('Sign in')
    fill_in('Email', with: 'lee@example.com')
    fill_in('Password', with: 'password')
    click_button('Log in')

    #And am on the home page
    #puts page.body
    assert_content page, 'Post Entry'
    visit root_path
    #When I click the Post Entry button
    click_link('Post Entry')
    #Then I should see a form for an entry
    assert_content page, 'Your Entry*'
    #When I input my entry
    fill_in('Your Entry', with: 'hi this is my entry!!!')
    click_button('Create Entry')
    #Then I should see my entry
    assert_content page, 'hi this is my entry!!!'

    #When I go to the index
    click_link('My Entries')
    #Then I should see a list of my entries
    assert_content page, 'Hey whats up guys im a post'
    assert_content page, 'hi this is my entry!!!'
    assert_no_content page, 'This is a post by notlee'
    #When I click an entry
    first(:link, "View").click
    #Then I should be brought to that page
    assert_content page, 'Hey whats up guys im a post'
    assert_no_content page, 'hi this is my entry!!!'

    #When I click edit
    click_link('Edit')
    #And change the post
    fill_in('Your Entry', with: 'this entry is modified')
    click_button('Update Entry')
    #Then my post should update
    assert_content page, 'this entry is modified'
    click_link('My Entries')
    assert_content page, 'this entry is modified'

    visit root_path
    #When I click others' entries
    click_link('Other Entries')
    #Then I should see a list of all entries that are not mine
    assert_no_content page, 'this entry is modified'
    assert_content page, 'This is a post by notlee'
    #When I click one
    first(:link, "View").click
    #Then I should be brought to that post
    assert_content page, 'This is a post by notlee'
    assert_no_content page, 'View'

  end


end
