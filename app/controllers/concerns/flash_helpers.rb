module FlashHelpers
  extend ActiveSupport::Concern

  private

  ##
  # Helper to set flash from string or object, for example:
  #
  #   flash_to 'Welcome back'   # => flash_to :success => 'Welcome back'
  #   flash_to :error => @user
  #
  def flash_to(*args)
    options = args.extract_options!
    unless options.is_a?(Hash)
      options = {:success => options}
    end
    flash_hash = options[:flash_hash] || flash
    options.each do |k, v|
      if v.respond_to?(:errors)
        flash_hash[k] = v.errors.full_messages.first
      else
        flash_hash[k] = v.to_s
      end
    end
  end

  ##
  # Same as flash_to, but uses flash.now
  #
  def flash_now(*args)
    options = args.extract_options!
    unless options.is_a?(Hash)
      options = {:success => options}
    end
    flash_to options.merge(:flash_hash => flash.now)
  end
end
