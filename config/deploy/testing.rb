server ENV['TESTING_APP_SERVER'], :web, :app, :db, primary: true
set :port, ENV['TESTING_SSH_PORT']
set :user, ENV['TESTING_DEPLOY_USER']
set :password, ENV['TESTING_DEPLOY_PASS']
set :deploy_to, "/home/#{user}/apps/#{application}"
