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

  ROLES = [:admin, :section_owner, :glossary_owner, :editor, :translator]
  validates :user_id, :role, presence: true
  validates :language_id, presence: true, unless: :admin?
  validates :role, inclusion: { in: ROLES.map(&:to_s) }

  def admin?
    role == :admin.to_s
  end

end
