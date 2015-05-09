# == Schema Information
#
# Table name: invoices
#
#  id          :integer          not null, primary key
#  user_id     :integer          not null
#  month       :integer          not null
#  year        :integer          not null
#  hours       :boolean          default(TRUE), not null
#  amount      :integer          default(0), not null
#  description :string(255)
#  sent_at     :datetime
#  status      :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Invoice < ActiveRecord::Base
  strip_attributes :only => [:status, :description]
  has_paper_trail :only => [:user_id, :month, :year, :sent_at, :status]

  belongs_to :user

  scope :by_year, ->(year) { where(year: year) }
  scope :by_month, ->(month) { where(month: month) }
  scope :by_period, ->(month, year) { where(month: month, year: year) }
  scope :list_order, -> { order('invoices.year DESC, invoices.month DESC') }

  STATUSES = [:draft, :sent, :paid]

  validates :user_id, :month, :year, :status, presence: true
  validates :month, :numericality => { greater_than: 0, less_or_equal_to: 12, only_integer: true }
  validates :year, :numericality => { greater_than: 2000, less_than: 2100, only_integer: true }
  validates :status, inclusion: {in: STATUSES.map(&:to_s), message: '%{value} is not a valid invoice status'}
  validates :amount, :numericality => { greater_or_equal_to: 0, only_integer: true }

  def period
    "#{Date::MONTHNAMES[month]} #{year}"
  end

  def period_for_email
    "#{year} #{Date::MONTHNAMES[month]}"
  end

  def unit
    hours? ? 'hours' : 'words'
  end

  def draft?
    status.to_s == 'draft'
  end

  def sent?
    status.to_s == 'sent'
  end

  def owned_by?(user)
    user && user.id == user_id
  end

  def sent!
    self.update_attributes!(
      status: 'sent',
      sent_at: Time.zone.now
      )
  end
end
