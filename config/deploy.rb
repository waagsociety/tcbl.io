# load Rails for env vars
require File.expand_path('../application', __FILE__)
require "bundler/capistrano"

#set multistage, live is production, testing is staging server
set :stages, %w(live testing)
set :default_stage, "testing"
require 'capistrano/ext/multistage'

set :bundle_flags,   "--deployment --verbose --without development test"
set :recipes, "config/recipes"

#production or staging
set :rails_env, "production"

# simple deploy scenario only for the stuff we really need: 
# we setup nginx + passenger by hand via installer! 
# base; includes precompilation
# redis; cache
# figaro; application.yml
# blacklist; words.yml
# rbenv: install ruby
# security: setup firewall + fail2ban
# postgresql: database
# nodejs: needed for uglifier / rake
#%w(base nodejs).each do |r|
%w(base redis figaro blacklist rbenv security postgresql nodejs).each do |r|
  load "#{recipes}/#{r}"
end

set :application, "tcbl.io"
set :deploy_via, :remote_cache
set :use_sudo, false
set :rake, "#{rake} --trace"

#for deploy from local copy
set :scm, :none
set :repository, "."
set :deploy_via, :copy

set :branch, "master"
set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
}

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :maintenance_template_path, File.expand_path("../recipes/templates/maintenance.html.erb", __FILE__)

after "deploy", "deploy:migrate", "deploy:cleanup", "post_deploy" # keep only the last 5 releases

require './config/boot' #run bundle

task :post_deploy do
	set :use_sudo, true
	
	#restart sidekiq mailer daemon
    sudo "service sidekiq restart"

	#execute precompilation
    run "cd apps/tcbl.io/current; RAILS_ENV=production bin/rake assets:precompile"	

	#restart nginx
	sudo "/etc/init.d/nginx restart"
	
end
