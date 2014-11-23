class UserMailer < ActionMailer::Base
  default :from => 'noreply@berzinarchives.org',
          :reply_to => 'noreply@berzinarchives.org'

  layout 'email'

  def password_reset_email(user, options = {})
    @user = user
    @password_reset_url = options[:password_reset_url]

    mail(
      :to => @user.email,
      :subject => 'Team Glossary password reset'
    )
  end

  def password_reset_confirmation_email(user, options = {})
    @user = user
    mail(
      :to => @user.email,
      :subject => 'Team Glossary password successfully changed'
    )
  end

  def welcome_email(user, options = {})
    @user = user
    @password_reset_url = options[:password_reset_url]

    mail(
      :to => @user.email,
      :subject => 'Welcome to Team Glossary'
    )
  end
end
