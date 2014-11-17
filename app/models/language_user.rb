# == Schema Information
#
# Table name: language_users
#
#  user_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#  level       :integer          default(0), not null
#  id          :integer          not null, primary key
#  language_id :integer
#  role        :string(255)      not null
#

class LanguageUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :language

  ROLES = [:manager, :editor, :user]
  validates :user_id, :role, presence: true
  validates :language_id, presence: true
  validates :role, inclusion: { in: ROLES.map(&:to_s) }
  validates :user_id, uniqueness: {case_sensitive: false, scope: [:language_id]}

  def glossary_owner?
    role == 'editor' && level == 4
  end

end
