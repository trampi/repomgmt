if ENV.has_key?("TRAVIS") then
    require "codeclimate-test-reporter"
    CodeClimate::TestReporter.start
end

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

	def travis_ci?
		return ENV.has_key?("TRAVIS")
	end

	def skip_on_travis_ci
		if travis_ci? then
			skip "test broken on travis ci"
		end
	end

	def windows?
		return Gem.win_platform?
	end

	def skip_on_windows
		if windows? then
			skip "test broken on windows"
		end
	end
end
