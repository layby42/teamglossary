# encoding: utf-8
# == Schema Information
#
# Table name: glossary_names
#
#  id                    :integer          not null, primary key
#  language_id           :integer          not null
#  proper_name_type_id   :integer          not null
#  integration_status_id :integer          not null
#  term                  :string(1000)     not null
#  tibetan               :string(255)
#  sanskrit              :string(255)
#  explanation           :text
#  is_private            :boolean          default(FALSE), not null
#  deleted               :boolean          default(FALSE), not null
#  created_at            :datetime
#  updated_at            :datetime
#  dates                 :string(255)
#  rejected_because      :text
#

class GlossaryName < ActiveRecord::Base
  include Approval
  include Search

  strip_attributes :only => [:term, :tibetan, :sanskrit, :explanation, :dates, :rejected_because]
  has_paper_trail :ignore => [:created_at, :updated_at]

  belongs_to :language
  belongs_to :proper_name_type
  belongs_to :integration_status

  has_many :glossary_name_translations
  has_many :comments, as: :commentable, dependent: :destroy

  scope :by_language, -> (language_id) { where(language_id: language_id) }
  scope :by_term, -> (term) { where('lower(glossary_names.term) = ?', term.to_s.strip.downcase) }
  scope :list_order, -> { order('lower(glossary_names.term)') }

  validates :term, :language_id, :proper_name_type_id, presence: true
  validates :term, uniqueness: {case_sensitive: false, scope: [:language_id, :proper_name_type_id], message: 'term already exists'}
  validates :term, uniqueness: {case_sensitive: false, scope: :proper_name_type_id, message: 'public term already exists'}, if: :is_public?

  SEARCH_COLUMNS = [:term, :tibetan, :sanskrit, :explanation, :dates]
  SEARCH_DEFAULT_COLUMNS = [:term, :tibetan, :sanskrit, :dates]
  SEARCH_TRANSLATION_COLUMNS = [:term, :alt_term1, :alt_term2, :alt_term3, :notes]
  SEARCH_DEFAULT_TRANSLATION_COLUMNS = [:term, :alt_term1, :alt_term2, :alt_term3]

  def is_public?
    is_private == false
  end

  def editable?
    true
  end

  def self.search(language, query, options={})
    columns = options[:columns].presence || SEARCH_COLUMNS
    columns = SEARCH_COLUMNS if columns.empty?
    columns = columns.map(&:to_sym) & SEARCH_COLUMNS

    states = (options[:states].presence || [:private, :public, :proposed]).map(&:to_sym)
    return [] if states.empty?

    query = query.to_s.strip.downcase

    if language.is_base_language?
      return [] if columns.empty?

      condition = GlossaryName.base_states_condition(language, states)

      GlossaryName.where(condition).list_order.includes([:proper_name_type, :comments, :language]).select do |term|
        columns.collect{|field| term.try(field).to_s}.join(' ').downcase.include?(query)
      end
    else
      translation_columns = options[:translation_columns].presence || SEARCH_TRANSLATION_COLUMNS
      translation_columns = SEARCH_TRANSLATION_COLUMNS if translation_columns.empty?
      translation_columns = translation_columns.map(&:to_sym) & SEARCH_TRANSLATION_COLUMNS

      return [] if (columns + translation_columns).empty?

      condition = GlossaryName.non_base_states_condition(language, states)

      GlossaryName.where(condition).list_order.includes([:glossary_name_translations, :proper_name_type, :comments, :language]).select do |term|

          columns.collect{|field| term.try(field).to_s}.join(' ').downcase.include?(query) ||
          (
            (
              transaction = term.glossary_name_translations.select{|t| t.language_id == language.id}.first) &&
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
    GlossaryName.new(
      integration_status: IntegrationStatus.default.first,
      proper_name_type: ProperNameType.default.first,
      is_private: true
    )
  end

  def has_translations?
    self.glossary_name_translations.count > 0
  end

  def has_no_transaltion?
    self.glossary_name_translations.count == 0
  end

  def translation_for_language(language_id)
    self.glossary_name_translations.by_language(language_id).first ||
    GlossaryNameTranslation.new_with_defaults
  end

  def translations_except_language(language_id)
    self.glossary_name_translations.except_language(language.id).includes([:language]).sort{|x,y| x.language.iso_code <=> y.language.iso_code}
  end

  def reject!(reason)
    base_language = Language.base_language
    return if self.language_id == base_language.id
     GlossaryName.transaction do
      self.rejected_because = reason
      self.is_private = true
      self.save!

      self.translations_except_language(self.language_id).each do |translation|
        t = self.dup
        t.language_id = translation.language_id

        if GlossaryName.by_language(translation.language_id).by_term(self.term).first
          t.term = "#{t.term} [DUPLICATE #{SecureRandom.hex(8)}]"
        end
        t.save!
        translation.update_attributes!(glossary_name_id: t.id)
      end
    end
  end
end
