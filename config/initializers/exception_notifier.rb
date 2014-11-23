# exception-notifier configuration

unless Rails.env.development? || Rails.env.test?
  TeamGlossary::Application.middleware.use ExceptionNotification::Rack,
    :email => {
      :email_prefix => "[TeamGlossary #{Rails.env}] ",
      :sender_address => '"Exception Notifier" <noreply@berzinarchives.org>',
      :exception_recipients => %w{goxana.a@gmail.com}
    },
    # ignore SMTP delivery errors
    :ignore_exceptions => ['Net::SMTPFatalError'] + ExceptionNotifier.ignored_exceptions
end
