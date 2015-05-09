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

  def work_in_progress_email(user, data, options={})
    @user = user
    @data = data
    @language = options[:language]
    @from_date = options[:from_date]
    @to_date = options[:to_date]

    mail(
      :to => @user.email,
      :subject => "work in progress (#{@to_date.strftime('%B %-d, %Y')})"
    )
  end

  def invoice_email(user, invoice, options={})
    @user = user
    @invoice = invoice
    @invoice_url = options[:invoice_url]

    to = Rails.env.production? ? 'invoices@berzinarchives.org' : 'goxana.a@gmail.com'
    mail(
      :to => to,
      :subject => "Invoice for #{user.name} #{invoice.period_for_email}"
    )
  end
end
