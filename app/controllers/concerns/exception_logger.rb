module ExceptionLogger
  extend ActiveSupport::Concern

  included do
    extend ExceptionLogger
  end

  private

  def log_exception(exception, notify = false)
    logger.error(exception.inspect)
    exception.backtrace.each do |frame|
      logger.error(frame)
    end
    ExceptionNotifier.notify_exception(exception, :env => request.env) if notify
  end
end
