DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

export RAILS_ENV=development

cat $DIR/tmp/pids/server.pid | xargs kill > /dev/null
sidekiqctl shutdown $DIR/tmp/pids/sidekiq.pid > /dev/null
