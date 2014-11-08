class UserMailer < ActionMailer::Base
  default :from => 'noreply@berzinarchives.org',
          :reply_to => 'noreply@berzinarchives.org'

  layout 'email'

  def password_reset_email(user, options = {})
    @user = user
    @confirm_url = options[:confirm_url]

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

  def activation_email(user, options={})
    @user = user
    @activation_url = options[:activation_url]
    mail(
      :to => @user.email,
      :subject => 'Team Glossary account activation'
    )
  end

  def welcome_email(user)
    @user = user
    mail(
      :to => @user.email,
      :subject => 'Welcome to Team Glossary'
    )
  end
end
