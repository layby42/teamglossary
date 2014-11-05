# encoding: utf-8
# == Schema Information
#
# Table name: glossary_names
#
#  id                    :integer          not null, primary key
#  language_id           :integer          not null
#  proper_name_type_id   :integer          not null
#  integration_status_id :integer          not null
#  term                  :string(255)      not null
#  tibetan               :string(255)
#  sanskrit              :string(255)
#  explanation           :text
#  is_private            :boolean          default(FALSE), not null
#  deleted               :boolean          default(FALSE), not null
#  created_at            :datetime
#  updated_at            :datetime
#  wade_giles            :string(255)
#  dates                 :string(255)
#

class GlossaryName < ActiveRecord::Base
  strip_attributes :only => [:term, :tibetan, :sanskrit, :explanation, :wade_giles, :dates]

  belongs_to :language
  belongs_to :proper_name_type
  belongs_to :integration_status

  has_many :glossary_name_translations

  scope :list_order, -> { order('lower(glossary_names.term)') }

  validates :term, :language_id, :proper_name_type_id, presence: true

  def self.simple_search(language, query)
    query = "%#{query}%"

    if language.is_base_language?
      GlossaryName.where(%Q{
        (glossary_names.language_id = ? OR
         NOT glossary_names.is_private)
        AND
        #{GlossaryName.ts_vector} ILIKE ?
        }, language.id, query).list_order.includes([:proper_name_type])
    else
      GlossaryName.where(%Q{
        (glossary_names.language_id = ? OR
          ( glossary_names.language_id = ? AND
            NOT glossary_names.is_private)
          ) AND
        (#{GlossaryName.ts_vector} ILIKE ?) OR
        EXISTS(
          SELECT glossary_name_translations.id
          FROM glossary_name_translations
          WHERE glossary_name_translations.language_id = glossary_names.language_id
            AND glossary_name_translations.glossary_name_id = glossary_names.id
            AND (#{GlossaryNameTranslation.ts_vector} ILIKE ?))
        }, language.id, Language.base_language.id, query, query).list_order.includes([:glossary_name_translations, :proper_name_type])
    end
  end

  def self.ts_vector
    [:term, :tibetan, :sanskrit, :explanation, :wade_giles, :dates].collect do |column|
      "coalesce(glossary_names.#{column}, '')"
    end.join(%q{ || ' ' || })
  end
end
