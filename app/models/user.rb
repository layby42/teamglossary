# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  login               :string(255)      not null
#  first_name          :string(255)      not null
#  last_name           :string(255)
#  crypted_password    :string(255)      not null
#  password_salt       :string(255)      not null
#  email               :string(255)      not null
#  last_login          :datetime
#  about               :text
#  created_at          :datetime
#  updated_at          :datetime
#  persistence_token   :string(255)      not null
#  single_access_token :string(255)      not null
#  perishable_token    :string(255)      not null
#  login_count         :integer          default(0), not null
#  failed_login_count  :integer          default(0), not null
#  last_request_at     :datetime
#  current_login_at    :datetime
#  last_login_at       :datetime
#  current_login_ip    :string(255)
#  last_login_ip       :string(255)
#  admin               :boolean          default(FALSE), not null
#  paid                :boolean          default(FALSE), not null
#

class User < ActiveRecord::Base
  acts_as_authentic do |config|
    config.login_field = :email
    config.perishable_token_valid_for = 1.week
    config.logged_in_timeout = 1.week
    config.merge_validates_length_of_login_field_options :within => 6..50
    config.merge_validates_length_of_password_field_options :within => 6..50
  end

  strip_attributes :only => [:email, :first_name, :last_name, :about]
  has_paper_trail :only => [:first_name, :last_name, :email, :admin, :about, :paid]

  has_many :language_users, dependent: :destroy
  has_and_belongs_to_many :languages, join_table: :language_users

  has_many :general_menu_actions

  has_many :settings, :as => :configurable, :dependent => :destroy

  has_many :invoices

  validates :email, presence: true, uniqueness: {case_sensitive: false}

  scope :by_language_ids, ->(language_ids) { joins(:language_users).where('language_users.language_id' => language_ids) }
  scope :list_order, -> { order('lower(users.first_name), lower(users.last_name)') }

  def email=(value)
    self[:email] = (value ? value.strip.downcase : value)
  end

  def name
    "#{first_name} #{last_name}"
  end

  def team_ids
    self.language_users.pluck(:language_id)
  end

  def team?(language_id)
    team_ids.include?(language_id)
  end

  def manager_language_ids
    self.language_users.where({role: :manager}).pluck(:language_id)
  end

  def manager_user_ids
    User.by_language_ids(manager_language_ids).pluck(:id)
  end

  def manager?(language_id=nil)
    return manager_language_ids.include?(language_id) if language_id.present?
    manager_language_ids.length > 0
  end

  def editor_language_ids
    self.language_users.where({role: :editor}).pluck(:language_id)
  end

  def editor?(language_id=nil)
    return editor_language_ids.include?(language_id) if language_id.present?
    editor_language_ids.length > 0
  end

  def manager_or_editor_language_ids
    self.language_users.where({role: [:editor, :manager]}).pluck(:language_id)
  end

  def manager_or_editor?(language_id=nil)
    return manager_or_editor_language_ids.include?(language_id) if language_id.present?
    manager_or_editor_language_ids.length > 0
  end

  def can_manage_user_team?(user)
    return true if user.admin?
    user_team_ids = user.team_ids
    return false if user_team_ids.empty?

    self.language_users.where({
      role: :manager,
      language_id: user_team_ids
      }).count > 0
  end

  def teams_count
    team_ids.length
  end

  def get_setting_value(setting_name)
    setting = self.settings.by_name(setting_name).first
    setting ? setting.value : nil
  end

  def write_access_languages
    Language.active.where(id: self.language_users.where(role: [:editor, :manager]).pluck(:language_id))
  end
end
