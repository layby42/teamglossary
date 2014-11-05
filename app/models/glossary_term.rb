# encoding: utf-8
# == Schema Information
#
# Table name: glossary_terms
#
#  id                     :integer          not null, primary key
#  language_id            :integer          not null
#  reference_type_id      :integer          not null
#  general_status_id      :integer          not null
#  integration_status_id  :integer          not null
#  glossary_term_id       :integer
#  term                   :string(255)      not null
#  tibetan                :string(255)
#  sanskrit               :string(255)
#  pali                   :string(255)
#  is_private             :boolean          default(FALSE), not null
#  created_at             :datetime
#  updated_at             :datetime
#  deleted                :boolean          default(FALSE)
#  arabic                 :string(255)
#  sanskrit_status_id     :integer          not null
#  alternative_tibetan    :string(255)
#  alternative_sanskrit   :string(255)
#  additional_explanation :text
#  sanscrit_gender        :string(255)
#  pali_gender            :string(255)
#

class GlossaryTerm < ActiveRecord::Base
  belongs_to :language
  belongs_to :reference_type
  belongs_to :integration_status
  belongs_to :glossary_term
  belongs_to :sanskrit_status

  has_many :glossary_term_definitions
  has_many :glossary_term_translations

  scope :list_order, -> { order('lower(glossary_terms.term)') }

  def self.simple_search(language, query)
    query = "%#{query}%"

    if language.is_base_language?
      GlossaryTerm.where(%Q{
        (glossary_terms.language_id = ? OR
         NOT glossary_terms.is_private)
        AND
        #{GlossaryTerm.ts_vector} ILIKE ?
        }, language.id, query).list_order
    else
      GlossaryTerm.where(%Q{
        (glossary_terms.language_id = ? OR
          ( glossary_terms.language_id = ? AND
            NOT glossary_terms.is_private)
          ) AND
        (#{GlossaryTerm.ts_vector} ILIKE ?) OR
        EXISTS(
          SELECT glossary_term_translations.id
          FROM glossary_term_translations
          WHERE glossary_term_translations.language_id = glossary_terms.language_id
            AND glossary_term_translations.glossary_term_id = glossary_terms.id
            AND (#{GlossaryTermTranslation.ts_vector} ILIKE ?))
        }, language.id, Language.base_language.id, query, query).list_order.includes([:glossary_term_translations])
    end
  end

  def self.ts_vector
    [ :term, :tibetan, :sanskrit, :pali, :arabic,
      :alternative_tibetan, :alternative_sanskrit, :additional_explanation].collect do |column|
      "coalesce(glossary_terms.#{column}, '')"
    end.join(%q{ || ' ' || })
  end
end
