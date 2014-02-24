set :application, "aaronaddleman.com"
set :repository,  "git@direct.aaronaddleman.com:aaronaddleman"
set :scm, :git
set :keep_releases, 15
set :deploy_via, :remote_cache
ssh_options[:user] = 'rvmuser'
set :use_sudo, false
default_run_options[:pty] = true
set :remote_user, 'rvmuser'
set :deploy_to, "/apps/#{application}"


role :web, "direct.aaronaddleman.com"                          # Your HTTP server, Apache/etc
role :app, "direct.aaronaddleman.com"                          # This may be the same as your `Web` serve r
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

namespace :check do
  task :site, :roles => :app do
    run("bash #{deploy_to}/current/content/attachments/scripts/check_site.sh > /dev/null 2>&1")
  end
end

namespace :sync do
  task :content do
    system("rsync -nvrltoDzO --progress --exclude-from 'exclude.txt' --delete-after -e ssh rvmuser@direct.aaronaddleman.com:/apps/aaronaddleman.com/current/* /Users/aaron/Documents/Work/personal/aaronaddleman-squaron")
    if prompt_y_n("Proceed? (y/n)")
      system("rsync -vrltoDzO --progress --exclude-from 'exclude.txt' --delete-after -e ssh rvmuser@direct.aaronaddleman.com:/apps/aaronaddleman.com/current/* /Users/aaron/Documents/Work/personal/aaronaddleman-squaron")
    end
  end
end

def prompt_y_n(question)
  logger.important "#{question} If they are okay, type y"
  response = Capistrano::CLI.ui.ask("Answer: ")

  if response.downcase =~ /(y|yes)/
    return true
  elseif response.downcase =~ /(n|no)/
    return false
  else
    logger.important "Abort."
    return false
  end
end