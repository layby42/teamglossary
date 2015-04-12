# == Schema Information
#
# Table name: general_menu_actions
#
#  id              :integer          not null, primary key
#  language_id     :integer          not null
#  general_menu_id :integer          not null
#  action          :string(255)
#  name            :string(255)
#  start_date      :date             not null
#  end_date        :date
#  created_at      :datetime
#  updated_at      :datetime
#  user_id         :integer
#  task_id         :integer          not null
#

class GeneralMenuAction < ActiveRecord::Base
  strip_attributes :only => [:name, :action]
  has_paper_trail :ignore => [:created_at, :updated_at]

  belongs_to :task
  belongs_to :user
  belongs_to :language
  belongs_to :general_menu

  scope :open, -> {where(end_date: nil)}
  scope :by_language, -> (language_id) { where(language_id: language_id) }

  scope :list_order, -> { order('general_menu_actions.start_date DESC, general_menu_actions.end_date DESC, general_menu_actions.id DESC') }

  scope :for_date_range, ->(from, to) { where(%q{
    (general_menu_actions.start_date BETWEEN ? AND ?) OR
    (general_menu_actions.end_date BETWEEN ? AND ?)
    }, from.beginning_of_day, to.end_of_day, from.beginning_of_day, to.end_of_day) }

  before_validation :adjust_assignee
  validate :language_id, :general_menu_id, :start_date, :task_id, presence: true

  def adjust_assignee
    if self[:user_id].present? && self[:name].present?
      self[:name] = nil
    elsif !self[:user_id].present? && !self[:name].present?
      self[:name] = 'Unknown'
    end
  end

  def self.simple_search(language, from, to)
    GeneralMenuAction.by_language(language.id).for_date_range(from, to).list_order.includes([:user, :task, :general_menu]).group_by{|a| a.general_menu}
  end
end
