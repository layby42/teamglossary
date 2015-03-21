# == Schema Information
#
# Table name: glossary_name_translations
#
#  id                    :integer          not null, primary key
#  language_id           :integer          not null
#  glossary_name_id      :integer          not null
#  integration_status_id :integer          not null
#  term                  :string(1000)     not null
#  alt_term1             :string(1000)
#  alt_term2             :string(1000)
#  alt_term3             :string(1000)
#  notes                 :text
#  created_at            :datetime
#  updated_at            :datetime
#

class GlossaryNameTranslation < ActiveRecord::Base
  strip_attributes :only => [:term, :alt_term1, :alt_term2, :alt_term3, :notes]
  has_paper_trail :ignore => [:created_at, :updated_at]

  belongs_to :language
  belongs_to :glossary_name
  belongs_to :integration_status

  scope :by_language, -> (language_id) { where(language_id: language_id) }
  scope :except_language, -> (language_id) { where('glossary_name_translations.language_id <> ?', language_id) }

  validates :term, :language_id, :glossary_name_id, presence: true
  validates :glossary_name_id, uniqueness: {scope: :language_id, case_sensitive: false}

  def self.new_with_defaults
    GlossaryNameTranslation.new(
      integration_status: IntegrationStatus.default.first
    )
  end

  def alt_terms_as_array
    [alt_term1, alt_term2, alt_term3].compact
  end
end
