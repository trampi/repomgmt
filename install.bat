call bundle install
call rake db:schema:load
echo run 'rake secret' and fill config/secrets.yml
