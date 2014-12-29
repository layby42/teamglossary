# == Schema Information
#
# Table name: languages
#
#  id               :integer          not null, primary key
#  iso_code         :string(10)       not null
#  english_name     :string(100)      not null
#  name             :string(100)      not null
#  is_base_language :boolean          default(FALSE)
#  is_active        :boolean          default(TRUE), not null
#  created_at       :datetime
#  updated_at       :datetime
#  encoding         :string(15)       default("UTF-8"), not null
#  notes            :string(4000)
#

class Language < ActiveRecord::Base
  has_many :language_users, dependent: :destroy
  has_and_belongs_to_many :users, join_table: :language_users

  has_many :glossary_names
  has_many :glossary_name_translations

  has_many :glossary_terms
  has_many :glossary_term_definition_translations
  has_many :glossary_term_translations

  has_many :glossary_titles
  has_many :glossary_title_translations

  has_many :general_menus
  has_many :general_menu_translations

  has_many :comments

  has_many :general_menu_actions

  strip_attributes :only => [:iso_code, :english_name, :name, :notes, :encoding]
  has_paper_trail :ignore => [:created_at, :updated_at]

  scope :base, -> { where(is_base_language: true)}
  scope :non_base, -> { where(is_base_language: false)}
  scope :active, -> { where(is_active: true)}
  scope :list_order, -> { order('lower(languages.iso_code)') }

  scope :except_languages, -> (language_ids) { where('id NOT IN (?)', language_ids) }

  validates :iso_code, presence: true, uniqueness: {case_sensitive: false}
  validates :english_name, :name, presence: true

  def full_name
    is_base_language ? name : "#{name}/#{english_name}"
  end

  def self.base_language
    @base_language = Language.base.first
  end
end
