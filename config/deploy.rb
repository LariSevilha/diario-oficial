# frozen_string_literal: true

require 'mina/git'

set :domain, 'cloud.agenciaw3.digital'
set :user, 'agenciaw3'
set :project_name, ''
set :deploy_to, "/home/#{user}/rails/#{project_name}/app"
set :volumes_to, "/home/#{user}/rails/#{project_name}/"
set :repository, ''
set :branch, 'deploy'
set :port, '63311'
set :term_mode, nil

set :shared_paths, ['.env']

task :setup do
  queue! %(mkdir -p "#{deploy_to}/shared")
  queue! %(mkdir -p "#{volumes_to}/storage")
  queue! %(mkdir -p "#{volumes_to}/database")
  queue! %(project_name=#{project_name} path_env=#{deploy_to}/#{shared_path}/.env bash ./project-setup.sh)
end

task :deploy do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'

    to :launch do
      invoke :'docker:down'
      invoke :'docker:build'
      invoke :'docker:yarn'
      invoke :'docker:prepare'
      invoke :'docker:precompile'
      invoke :'docker:up'
    end
  end
end

namespace :docker do
  desc 'Stop docker compose if is running and remove all dangling images'
  task :down do
    queue "cd #{deploy_to}/#{current_path}"
    queue 'docker compose down'
  end

  desc 'Build docker compose'
  task :build do
    queue "cd #{deploy_to}/#{current_path}"
    queue 'docker compose build'
  end

  desc 'Install yarn dependencies'
  task :yarn do
    queue "cd #{deploy_to}/#{current_path}"
    queue 'docker compose run --rm app yarn'
  end

  desc 'Prepare database for rails'
  task :prepare do
    queue "cd #{deploy_to}/#{current_path}"
    queue 'docker compose run --rm app rake db:create db:migrate'
  end

  desc 'Precompile the assets'
  task :precompile do
    queue "cd #{deploy_to}/#{current_path}"
    queue 'docker compose run --rm app rake assets:precompile RAILS_ENV=production'
  end

  desc 'Create sitemaps and ping search engines'
  task :sitemap_refresh do
    queue "cd #{deploy_to}/#{current_path}"
    queue "docker compose run --rm app rake sitemap:refresh CONFIG_FILE='config/sitemap.rb'"
  end

  desc 'Update the crontab to run sitemap'
  task :sitemap_crontab do
    queue "cd #{deploy_to}/#{current_path}"
    queue 'docker compose run --rm app whenever --update-crontab'
  end

  desc 'Start docker compose'
  task :up do
    queue "cd #{deploy_to}/#{current_path}"
    queue 'docker compose up -d'
    queue 'docker image prune -f'
    queue 'docker container prune -f'
    queue %(echo "-----> Server is up!")
  end
end

desc 'Precompile the assets'
task :precompile do
  queue "cd #{deploy_to}/#{current_path}"
  queue 'docker compose exec app rake assets:precompile RAILS_ENV=production'
  queue 'docker compose restart'
  queue  %(echo "-----> Server is up!")
end

desc 'Show logs app'
task :logs do
  queue! %(tail -f "#{deploy_to}/#{shared_path}/production.log")
end

desc 'Access rails console'
task :console do
  queue "cd #{deploy_to}/#{current_path}"
  queue 'docker compose exec app rails c'
end
