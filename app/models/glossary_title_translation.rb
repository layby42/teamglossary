# == Schema Information
#
# Table name: glossary_title_translations
#
#  id                    :integer          not null, primary key
#  language_id           :integer          not null
#  glossary_title_id     :integer          not null
#  integration_status_id :integer          not null
#  term                  :string(1000)     not null
#  alt_term1             :string(1000)
#  alt_term2             :string(1000)
#  alt_term3             :string(1000)
#  author                :string(255)
#  notes                 :text
#  created_at            :datetime
#  updated_at            :datetime
#

class GlossaryTitleTranslation < ActiveRecord::Base
  strip_attributes :only => [:term, :alt_term1, :alt_term2, :alt_term3, :notes, :author]
  has_paper_trail :ignore => [:created_at, :updated_at]

  belongs_to :language
  belongs_to :glossary_title
  belongs_to :integration_status

  scope :by_language, -> (language_id) { where(language_id: language_id) }
  scope :except_language, -> (language_id) { where('glossary_title_translations.language_id <> ?', language_id) }

  validates :term, :language_id, :glossary_title_id, presence: true
  validates :glossary_title_id, uniqueness: {scope: :language_id, case_sensitive: false}

  def self.new_with_defaults
    GlossaryTitleTranslation.new(
      integration_status: IntegrationStatus.default.first
    )
  end
end
