# == Schema Information
#
# Table name: general_menu_actions
#
#  id              :integer          not null, primary key
#  language_id     :integer
#  general_menu_id :integer
#  action          :string(255)
#  name            :string(255)
#  start_date      :date
#  end_date        :date
#  created_at      :datetime
#  updated_at      :datetime
#  user_id         :integer
#  task_id         :integer          not null
#

class GeneralMenuAction < ActiveRecord::Base
  strip_attributes :only => [:name]
  has_paper_trail :ignore => [:created_at, :updated_at]

  belongs_to :task
  belongs_to :user
  belongs_to :language
  belongs_to :general_menu

  scope :open, -> {where(end_date: nil)}
  scope :by_language, -> (language_id) { where(language_id: language_id) }
  scope :list_order, -> { order('general_menu_actions.start_date DESC') }

  before_validation :adjust_assignee
  validate :language_id, :general_menu_id, :start_date, :task_id, presence: true

  def adjust_assignee
    if self[:user_id].present? && self[:name].present?
      self[:name] = nil
    elsif !self[:user_id].present? && !self[:name].present?
      self[:name] = 'Unknown'
    end
  end

end
