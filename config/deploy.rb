lock '3.3.5'

set :application, 'teamglossary'
set :repo_url, 'git@bitbucket.org:ogoutnik/teamglossary.git'

set :deploy_to, "~/apps/#{fetch(:application)}"
set :rvm_ruby_version, '2.1.3'

# namespace :deploy do

#   desc 'Restart application'
#   task :restart do
#     on roles(:app), in: :sequence, wait: 5 do
#       # Your restart mechanism here, for example:
#       # execute :touch, release_path.join('tmp/restart.txt')
#     end
#   end

#   after :publishing, :restart

#   after :restart, :clear_cache do
#     on roles(:web), in: :groups, limit: 3, wait: 10 do
#       # Here we can do anything such as:
#       # within release_path do
#       #   execute :rake, 'cache:clear'
#       # end
#     end
#   end

# end
