ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/rails"
require "minitest/rails/capybara"

require "minitest/reporters"
Minitest::Reporters.use!(
    Minitest::Reporters::DefaultReporter.new,
    ENV,
    Minitest.backtrace_filter
)

include Devise::TestHelpers
include Warden::Test::Helpers
Warden.test_mode!

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  private

    # Returns true inside an integration test.
    def integration_test?
      defined?(post_via_redirect)
    end

end
