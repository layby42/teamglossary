set :application, 'teamglossary'
set :deploy_to, "~/apps/teamglossary"
server 'webglossary.berzinarchives.org', user: 'rails', roles: %w{web app db}
