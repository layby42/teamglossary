# == Schema Information
#
# Table name: tasks
#
#  id             :integer          not null, primary key
#  title          :string(255)      not null
#  article        :boolean          default(FALSE), not null
#  audio          :boolean          default(FALSE), not null
#  video          :boolean          default(FALSE), not null
#  created_at     :datetime
#  updated_at     :datetime
#  title_complete :string(255)      not null
#

class Task < ActiveRecord::Base
  strip_attributes :only => [:title, :article]
  has_paper_trail :ignore => [:created_at, :updated_at]

  has_many :general_menu_actions

  scope :list_order, -> { order('lower(tasks.title)') }

  validates :title, presence: true, uniqueness: {case_sensitive: false}
  validates :title_complete, presence: true

  def show_assignee_in_email?
    ['transcribing', 'translation', 'proofreading'].include?(title.downcase)
  end
end
