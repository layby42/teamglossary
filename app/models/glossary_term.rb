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
#  sanskrit_status_id     :integer          not null
#  alternative_tibetan    :string(255)
#  alternative_sanskrit   :string(255)
#  additional_explanation :text
#  sanskrit_gender        :string(255)
#  pali_gender            :string(255)
#  definition             :text
#  is_definition_private  :boolean          default(FALSE), not null
#  rejected_because       :text
#

class GlossaryTerm < ActiveRecord::Base
  include Approval

  strip_attributes :only => [:term, :tibetan, :sanskrit, :pali, :alternative_tibetan, :alternative_sanskrit, :additional_explanation, :sanskrit_gender, :pali_gender, :definition, :rejected_because]
  has_paper_trail :ignore => [:created_at, :updated_at]

  belongs_to :language
  belongs_to :reference_type
  belongs_to :integration_status
  belongs_to :general_status
  belongs_to :glossary_term
  belongs_to :sanskrit_status

  has_many :glossary_term_translations
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :glossary_terms

  scope :by_language, -> (language_id) { where(language_id: language_id) }
  scope :by_term, -> (term) { where('lower(glossary_terms.term) = ?', term.to_s.strip.downcase) }
  scope :list_order, -> { order('lower(glossary_terms.term)') }

  validates :term, :language_id, presence: true
  validates :term, uniqueness: {case_sensitive: false, scope: :language_id, message: 'term already exists'}
  validates :term, uniqueness: {case_sensitive: false, message: 'public term already exists'}, if: :is_public?

  SEARCH_COLUMNS = [
      :term, :tibetan, :sanskrit, :pali,
      :alternative_tibetan, :alternative_sanskrit,
      :additional_explanation, :definition]

  SEARCH_TRANSLATION_COLUMNS = [
    :term, :alt_term1, :alt_term2, :alt_term2, :notes, :definition
  ]

  def is_public?
    is_private == false
  end

  def editable?
    true
  end

  def self.search(language, query, options={})
    columns = options[:columns].presence || SEARCH_COLUMNS
    translation_columns = options[:translation_columns].presence || SEARCH_TRANSLATION_COLUMNS

    query = query.to_s.strip.downcase
    columns = SEARCH_COLUMNS if columns.empty?
    if language.is_base_language?
      GlossaryTerm.where(%Q{
        (glossary_terms.language_id = ? OR
         NOT glossary_terms.is_private)
        }, language.id).list_order.select do |term|
        columns.collect{|field| term.try(field).to_s}.join(' ').downcase.include?(query)
      end
    else
      translation_columns = SEARCH_TRANSLATION_COLUMNS if translation_columns.empty?

      GlossaryTerm.where(%Q{
        (glossary_terms.language_id = ? OR
          ( glossary_terms.language_id = ? AND
            NOT glossary_terms.is_private)
          )
        }, language.id, Language.base_language.id).list_order.includes([:glossary_term_translations]).select do |term|

          columns.collect{|field| term.try(field).to_s}.join(' ').downcase.include?(query) ||
          (
            (
              transaction = term.glossary_term_translations.select{|t| t.language_id == language.id}.first
            ) &&
              translation_columns.collect do |field|
                transaction.try(field).to_s
              end.join(' ').downcase.include?(query)
          )
      end
    end
  end

  def last_comment(language_id=nil)
    if language_id.present?
      self.comments.by_language(language_id).list_order.limit(1).includes([:user]).first
    else
      self.comments.list_order.limit(1).includes([:user]).first
    end
  end

  def self.new_with_defaults
    GlossaryTerm.new(
      integration_status: IntegrationStatus.default.first,
      reference_type: ReferenceType.default.first,
      general_status: GeneralStatus.default.first,
      sanskrit_status: SanskritStatus.default.first,
      is_private: true,
      is_definition_private: true
    )
  end

  def has_translations?
    self.glossary_term_translations.count > 0
  end

  def has_no_transaltion?
    self.glossary_term_translations.count == 0
  end

  def translation_for_language(language_id)
    self.glossary_term_translations.by_language(language_id).first ||
    GlossaryTermTranslation.new_with_defaults
  end

  def translations_except_language(language_id)
    self.glossary_term_translations.except_language(language.id).includes([:language]).sort{|x,y| x.language.iso_code <=> y.language.iso_code}
  end

  def reject!(reason)
    base_language = Language.base_language
    return if self.language_id == base_language.id
     GlossaryTerm.transaction do
      self.rejected_because = reason
      self.is_private = true
      self.save!

      self.translations_except_language(self.language_id).each do |translation|
        t = self.dup
        t.language_id = translation.language_id

        if GlossaryTerm.by_language(translation.language_id).by_term(self.term).first
          t.term = "#{t.term} [DUPLICATE #{SecureRandom.hex(8)}]"
        end
        t.save!
        translation.update_attributes!(glossary_term_id: t.id)
      end
    end
  end
end
