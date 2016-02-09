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
%w(base redis figaro blacklist rbenv security).each do |r|
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

after "deploy", "deploy:migrate", "deploy:cleanup" # keep only the last 5 releases

require './config/boot' #run bundle

task :uname do
	  run "uname -a"
end
