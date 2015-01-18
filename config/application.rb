require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Repomgmt
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :de

    config.active_record.raise_in_transactional_callbacks = true
    config.autoload_paths += %W["#config.root/app/validators"]
    config.filter_parameters << :gauth_secret << :gauth_enabled << :gauth_tmp << :gauth_tmp_datetime << :gauth_token

    config.action_mailer.default_url_options = { host: 'localhost:3000' }

    config.repomgmt = ActiveSupport::OrderedOptions.new

    # path to your checked out gitolite admin repository (not the bare repository of gitolite!)
    config.repomgmt.gitolite_repository = '/var/repomgmt/gitolite-admin-repository'

    # url to use as prefix for repositories.
    config.repomgmt.repository_url_prefix = 'ssh://gitolite@192.168.56.101:'

    # configure this to match the directory where your repositories lie in.
    config.repomgmt.repository_root_path = '/var/repomgmt/repositories'

    # configure the commiter email
    config.repomgmt.email = 'repomgmt@example.com'

    # trigger repository reindex with a HTTP-Get-Request to <application>/reindex?secret=<this_value_here>
    config.repomgmt.reindex_secret = 'changeme'

    # disable public registration if set to true
    config.repomgmt.disable_public_registration = false
  end
end
