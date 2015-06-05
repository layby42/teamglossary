# == Schema Information
#
# Table name: general_menu_translations
#
#  id                  :integer          not null, primary key
#  language_id         :integer
#  general_menu_id     :integer
#  name                :string(1000)     not null
#  online              :date
#  notes               :text
#  created_at          :datetime
#  updated_at          :datetime
#  additional_text     :text
#  cms_updated         :date
#  synchronized        :boolean          default(FALSE), not null
#  updated_from_cms_at :datetime
#  new_name            :string(1000)
#

class GeneralMenuTranslation < ActiveRecord::Base
  strip_attributes :only => [:name, :notes, :additional_text, :new_name]
  has_paper_trail :ignore => [:created_at, :updated_at, :updated_from_cms_at, :cms_updated]

  belongs_to :language
  belongs_to :general_menu

  scope :by_language, -> (language_id) { where(language_id: language_id) }
  scope :except_language, -> (language_id) { where('general_menu_translations.language_id <> ?', language_id) }

  validates :name, :language_id, :general_menu_id, presence: true
  validates :general_menu_id, uniqueness: {scope: :language_id}

  def term
    name
  end

  def self.new_with_defaults
    GeneralMenuTranslation.new
  end
end
