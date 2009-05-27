#!/usr/bin/env ruby
## lib/tasks/git.rake
# 
# Rake task to fully copy your master database into a new database for current branch.
# Sample usage:
# 
#   rake git:db:clone
# 
# What gets run:
# 
#   cp #{from} #{target}
#   mysqldump -u #{user} #{from} | mysql -u #{user} #{target}
# 
namespace :git do
  namespace :db do
    desc "Branch your development database"
    task :clone => :environment do
      require 'fileutils'
      require 'config/boot'
      require 'git_conf'
      
      config   = GitConf.new
      dbconfig = config.database_configuration["development"]
    
      if config.branched_database?
        user = dbconfig["username"]
        from = dbconfig["master-database"]
        to   = dbconfig["database"]
        
        FileUtils.cp(from, to)
      else
        warn "branch isn't configured for a separate database"
      end
    end
    namespace :canonical do
      desc "Clone Canonical idp.data Git database"
      task :clone => :environment do
        require 'config/boot'
        
        CANONICAL_CLONE_URL = "git://halsted.vis.uky.edu/git/idp.data.git"
        
        clone_command = ["git clone --bare",
                        CANONICAL_CLONE_URL,
                        CANONICAL_REPOSITORY].join(' ')
        
        system(clone_command)
      end
    end
  end
end