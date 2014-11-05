# == Schema Information
#
# Table name: languages
#
#  id               :integer          not null, primary key
#  iso_code         :string(255)      not null
#  english_name     :string(255)      not null
#  name             :string(255)      not null
#  is_base_language :boolean          default(FALSE)
#  is_active        :boolean          default(TRUE), not null
#  created_at       :datetime
#  updated_at       :datetime
#  encoding         :string(255)      default("ISO-8859-1"), not null
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

  scope :base, -> { where(is_base_language: true)}
  scope :active, -> { where(is_active: true)}
  scope :list_order, -> { order('lower(languages.iso_code)') }

  validates :iso_code, presence: true, uniqueness: {case_sensitive: false}
  validates :english_name, :name, presence: true

  def full_name
    is_base_language ? name : "#{name}/#{english_name}"
  end

  def self.base_language
    @base_language = Language.base.first
  end
end
