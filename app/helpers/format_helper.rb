module FormatHelper
  def as_boolean(value)
    value.to_s =~ (/^(true|t|yes|y|1)$/i)
  end

  def as_date(value, default='')
    value ? value.in_time_zone.strftime('%m/%d/%Y') : default
  end

  def as_datetime(value, default='')
    value ? value.in_time_zone.strftime('%m/%d/%Y %H:%M') : ''
  end

end
