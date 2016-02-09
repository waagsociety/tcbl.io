server ENV['PRODUCTION_APP_SERVER'], :web, :app, :db, primary: true
set :port, ENV['PRODUCTION_SSH_PORT']
set :user, ENV['PRODUCTION_DEPLOY_USER']
set :password, ENV['PRODUCTION_DEPLOY_PASS']
set :deploy_to, "/home/#{user}/apps/#{application}"
