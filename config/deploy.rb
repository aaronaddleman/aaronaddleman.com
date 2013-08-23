set :application, "aaronaddleman.com"
set :repository,  "git@www.squaron.net:aaronaddleman"
set :scm, :git
set :keep_releases, 15
set :app_root, "wordpress"
set :deploy_via, :remote_cache
ssh_options[:user] = 'deployer'
set :use_sudo, false
default_run_options[:pty] = true
set :remote_user, 'deployer'
set :deploy_to, "/apps/#{application}"


role :web, "www.squaron.net"                          # Your HTTP server, Apache/etc
role :app, "www.squaron.net"                          # This may be the same as your `Web` serve r
# role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end