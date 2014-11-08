# ActionMailer configuration

TeamGlossary::Application.configure do
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address              => 'smtp.mailgun.org',
    :port                 => 587,
    :user_name            => 'postmaster@berzinarchives.com',
    :password             => 'f3c5ed8a751868e938fd87ad5070bf69',
    :authentication       => :plain,
    :enable_starttls_auto => true
  }
end
