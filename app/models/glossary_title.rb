# encoding: utf-8
# == Schema Information
#
# Table name: glossary_titles
#
#  id                     :integer          not null, primary key
#  language_id            :integer          not null
#  integration_status_id  :integer          not null
#  term                   :string(255)      not null
#  author                 :string(255)
#  tibetan_full           :string(255)
#  tibetan_short          :string(255)
#  sanskrit_full          :string(255)
#  sanskrit_short         :string(255)
#  sanskrit_full_diacrit  :string(255)
#  sanskrit_short_diacrit :string(255)
#  explanation            :text
#  is_private             :boolean          default(FALSE), not null
#  deleted                :boolean          default(FALSE), not null
#  created_at             :datetime
#  updated_at             :datetime
#  author_translit        :string(255)
#  alt_term1              :string(255)
#  alt_term2              :string(255)
#  popular_term           :string(255)
#  pali                   :string(255)
#

class GlossaryTitle < ActiveRecord::Base
  belongs_to :language
  belongs_to :integration_status

  has_many :glossary_title_translations

  scope :list_order, -> { order('lower(glossary_titles.term)') }

  validates :term, :language_id, :integration_status_id, presence: true

  def self.simple_search(language, query)
    query = "%#{query}%"

    if language.is_base_language?
      GlossaryTitle.where(%Q{
        (glossary_titles.language_id = ? OR
         NOT glossary_titles.is_private)
        AND
        #{GlossaryTitle.ts_vector} ILIKE ?
        }, language.id, query)
    else
      GlossaryTitle.where(%Q{
        (glossary_titles.language_id = ? OR
          ( glossary_titles.language_id = ? AND
            NOT glossary_titles.is_private)
          ) AND
        (#{GlossaryTitle.ts_vector} ILIKE ?) OR
        EXISTS(
          SELECT glossary_title_translations.id
          FROM glossary_title_translations
          WHERE glossary_title_translations.language_id = glossary_titles.language_id
            AND glossary_title_translations.glossary_title_id = glossary_titles.id
            AND (#{GlossaryTitleTranslation.ts_vector} ILIKE ?))
        }, language.id, Language.base_language.id, query, query).includes([:glossary_title_translations])
    end
  end

  def self.ts_vector
    [ :term, :author, :author_translit,
      :tibetan_full, :tibetan_short,
      :sanskrit_full, :sanskrit_short,
      :sanskrit_full_diacrit, :sanskrit_short_diacrit,
      :explanation, :alt_term1, :alt_term2,
      :popular_term, :pali].collect do |column|
      "coalesce(glossary_titles.#{column}, '')"
    end.join(%q{ || ' ' || })
  end
end
