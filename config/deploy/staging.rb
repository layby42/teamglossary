set :application, 'teamglossary-staging'
set :deploy_to, "~/apps/teamglossary-staging"
server 'teamglossary.syrec.org', user: 'rails', roles: %w{web app db}
