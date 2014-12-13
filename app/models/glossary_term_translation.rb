# == Schema Information
#
# Table name: glossary_term_translations
#
#  id                    :integer          not null, primary key
#  language_id           :integer          not null
#  glossary_term_id      :integer          not null
#  integration_status_id :integer          not null
#  term                  :string(255)      not null
#  created_at            :datetime
#  updated_at            :datetime
#  alt_term1             :string(255)
#  alt_term2             :string(255)
#  alt_term3             :string(255)
#  notes                 :text
#  term_gender           :string(255)
#  definition            :text
#

class GlossaryTermTranslation < ActiveRecord::Base
  strip_attributes :only => [:term, :alt_term1, :alt_term2, :alt_term3, :notes, :term_gender, :definition]
  has_paper_trail :ignore => [:created_at, :updated_at]

  belongs_to :language
  belongs_to :glossary_term
  belongs_to :integration_status

  scope :by_language, -> (language_id) { where(language_id: language_id) }
  scope :except_language, -> (language_id) { where('glossary_term_translations.language_id <> ?', language_id) }

  def self.new_with_defaults
    GlossaryTermTranslation.new(
      integration_status: IntegrationStatus.default.first
    )
  end
end
