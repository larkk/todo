# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'askmehowto'
set :repo_url, 'git@github.com:hrairadil/askmehowto.git'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/ubuntu/askmehowto'
set :deploy_user, 'ubuntu'

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push(
                     'config/database.yml',
                     'config/secrets.yml',
                     'config/private_pub.yml',
                     '.env',
                     'config/private_pub_thin.yml',
                     'config/production.sphinx.conf',
                     'config/thinking_sphinx.yml'
                 )

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push(
                    'log',
                    'tmp/pids',
                    'tmp/cache',
                    'tmp/sockets',
                    'vendor/bundle',
                    'public/system',
                    'public/uploads'
                )

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart
end

namespace :private_pub do
  desc 'Start private_pub server'
  task :start do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec thin -C config/private_pub_thin.yml start'
        end
      end
    end
  end

  desc 'Stop private_pub server'
  task :stop do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec thin -C config/private_pub_thin.yml stop'
        end
      end
    end
  end

  desc 'Restart private_pub server'
  task :restart do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec thin -C config/private_pub_thin.yml restart'
        end
      end
    end
  end

  after 'deploy:restart', 'private_pub:restart'
end

namespace :sphinx do
  desc 'Start thinking sphinx server'
  task :start do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec rake ts:start'
        end
      end
    end
  end

  desc 'Stop thinking sphinx server'
  task :stop do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec rake ts:stop'
        end
      end
    end
  end

  desc 'Restart thinking sphinx server'
  task :restart do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec rake ts:restart'
        end
      end
    end
  end

  desc 'Index thinking sphinx server'
  task :index do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec rake ts:index'
        end
      end
    end
  end

  desc 'Configure thinking sphinx server'
  task :configure do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec rake ts:configure'
        end
      end
    end
  end

  desc 'Rebuild thinking sphinx server'
  task :rebuild do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec rake ts:rebuild'
        end
      end
    end
  end

  after 'deploy:restart', 'sphinx:rebuild'
end
