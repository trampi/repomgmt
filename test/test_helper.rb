require 'simplecov'
SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'global_setup'

class ActiveSupport::TestCase
	# Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
	#
	# Note: You'll currently still have to declare fixtures explicitly in integration tests
	# -- they do not yet inherit this setting
	fixtures :all
	GlobalTestSetup.new fixture_path

	def skip_on_travis_ci
		if ENV.has_key?("TRAVIS_CI") then
			skip "test broken on travis ci"
		end
	end

end
