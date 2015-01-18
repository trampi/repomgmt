DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

export RAILS_ENV=production
export DISABLE_SPRING=true

cd $DIR

$DIR/bin/rake db:migrate
$DIR/bin/bundle exec sidekiq -c 1 -d --logfile log/sidekiq.log -P tmp/pids/sidekiq.pid
$DIR/bin/rails server -b 0.0.0.0 > /dev/null &
