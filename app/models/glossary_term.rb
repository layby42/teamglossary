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
#  term                   :string(1000)     not null
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
  include Search

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

  SEARCH_DEFAULT_COLUMNS = [:term]

  SEARCH_TRANSLATION_COLUMNS = [:term, :alt_term1, :alt_term2, :alt_term3, :notes, :definition]
  SEARCH_DEFAULT_TRANSLATION_COLUMNS = [:term, :alt_term1, :alt_term2, :alt_term3]

  SEARCH_EXTRA = [:term_translated, :definition_translated, :translation_notes]

  def tibetan=(value)
    self[:tibetan] = (value ? value.gsub('‘', '''') : value)
  end

  def alternative_tibetan=(value)
    self[:alternative_tibetan] = (value ? value.gsub('‘', '''') : value)
  end

  def is_public?
    is_private == false
  end

  def self.search(language, query, options={})
    columns = (options[:columns].presence || SEARCH_COLUMNS).map(&:to_sym)
    columns = SEARCH_COLUMNS if columns.empty?
    columns = columns & SEARCH_COLUMNS

    states = (options[:states].presence || [:private, :public, :proposed]).map(&:to_sym)
    return [] if states.empty?

    extra = (options[:extra].presence || []).map(&:to_sym)
    search_contains = (options[:search_contains] == true)

    query = query.to_s.mb_chars.downcase.to_s.strip

    if language.is_base_language?
      return [] if columns.empty?

      condition = GlossaryTerm.base_states_condition(language, states)

      GlossaryTerm.where(condition).list_order.includes([:comments, :language]).select do |term|
        if search_contains
          columns.any?{|field| term.try(field).to_s.mb_chars.downcase.to_s.include?(query) }
        else
          columns.any?{|field| term.try(field).to_s.mb_chars.downcase.to_s.index(query) == 0 }
        end
      end
    else
      translation_columns = (options[:translation_columns].presence || SEARCH_TRANSLATION_COLUMNS).map(&:to_sym)
      translation_columns = SEARCH_TRANSLATION_COLUMNS if translation_columns.empty?
      translation_columns = translation_columns & SEARCH_TRANSLATION_COLUMNS

      return [] if (columns + translation_columns).empty?

      condition = GlossaryTerm.non_base_states_condition(language, states)
      extra_condition = GlossaryTerm.extra_condition(language, extra)

      GlossaryTerm.where(condition).where(extra_condition).list_order.includes([:glossary_term_translations, :comments, :language]).select do |term|
        transaction = term.glossary_term_translations.select{|t| t.language_id == language.id}.first

        if search_contains
          columns.any?{|field| term.try(field).to_s.downcase.include?(query) } ||
          (
            transaction && translation_columns.any?{|field| transaction.try(field).to_s.mb_chars.downcase.to_s.include?(query) }
          )
        else
          columns.any?{|field| term.try(field).to_s.downcase.index(query) == 0 } ||
          (
            transaction && translation_columns.any?{|field| transaction.try(field).to_s.mb_chars.downcase.to_s.index(query) == 0 }
          )
        end
      end
    end
  end

  def self.extra_condition(language, extra=[])
    return 'TRUE' unless extra.present?
    return 'TRUE' if (extra & [:term_translated, :definition_translated, :translation_notes]) == 0

    conditions = [%q{
        glossary_term_translations.glossary_term_id = glossary_terms.id AND
        glossary_term_translations.language_id = ?
      }]

    if extra.include?(:definition_translated)
      conditions << 'glossary_term_translations.definition IS NOT NULL'
    end

    if extra.include?(:translation_notes)
      conditions << 'glossary_term_translations.notes IS NOT NULL'
    end

    [
      %Q{
        EXISTS( SELECT glossary_term_translations.id
          FROM glossary_term_translations
          WHERE #{conditions.join(' AND ')})
      }, language.id
    ]
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
