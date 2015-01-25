if ENV.key?('JENKINS')
  require 'codeclimate-test-reporter'
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

  def setup
    repositories(:repository_one).index_commits_if_changed
    repositories(:repository_two).index_commits_if_changed
  end

  def cleanup_repository_fixtures
    GlobalTestSetup.new fixture_path
  end

  def travis_ci?
    ENV.key?('TRAVIS')
  end

  def skip_on_travis_ci
    skip 'test broken on travis ci' if travis_ci?
  end

  def windows?
    Gem.win_platform?
  end

  def skip_on_windows
    skip 'test broken on windows' if windows?
  end
end
