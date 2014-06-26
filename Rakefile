ssh_user = "web@isthelibraryopen.com"
remote_root = "~/itlo.crnixon.org/"

desc "Builds the site"
task :build do
  puts "*** Building the site ***"
  system("bundle exec middleman build")
end

desc "Deploys site"
task :deploy => :build do
  puts "*** Deploying the site ***"
  system("rsync -avz --delete build/ #{ssh_user}:#{remote_root}")
end
