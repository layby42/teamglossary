# encoding: utf-8
# == Schema Information
#
# Table name: glossary_titles
#
#  id                     :integer          not null, primary key
#  language_id            :integer          not null
#  integration_status_id  :integer          not null
#  term                   :string(1000)     not null
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
#  alt_term1              :string(1000)
#  alt_term2              :string(1000)
#  popular_term           :string(1000)
#  pali                   :string(255)
#  rejected_because       :text
#

class GlossaryTitle < ActiveRecord::Base
  include Approval
  include Search

  strip_attributes :only => [:term, :alt_term1, :alt_term2, :popular_term, :author, :author_translit, :tibetan_full, :tibetan_short, :sanskrit_full, :sanskrit_short, :sanskrit_full_diacrit, :sanskrit_short_diacrit, :pali, :explanation, :rejected_because]
  has_paper_trail :ignore => [:created_at, :updated_at]

  belongs_to :language
  belongs_to :integration_status

  has_many :glossary_title_translations
  has_many :comments, as: :commentable, dependent: :destroy

  scope :by_language, -> (language_id) { where(language_id: language_id) }
  scope :by_term, -> (term) { where('lower(glossary_titles.term) = ?', term.to_s.strip.downcase) }
  scope :list_order, -> { order('lower(glossary_titles.term)') }

  validates :term, :language_id, :integration_status_id, presence: true
  validates :term, uniqueness: {case_sensitive: false, scope: :language_id, message: 'term already exists'}
  validates :term, uniqueness: {case_sensitive: false, message: 'public term already exists'}, if: :is_public?

  SEARCH_COLUMNS = [ :term, :author, :author_translit,
      :tibetan_full, :tibetan_short,
      :sanskrit_full, :sanskrit_short,
      :sanskrit_full_diacrit, :sanskrit_short_diacrit,
      :explanation, :alt_term1, :alt_term2,
      :popular_term, :pali]

  SEARCH_DEFAULT_COLUMNS = [:term,
      :alt_term1, :alt_term2,
      :popular_term]

  SEARCH_TRANSLATION_COLUMNS = [ :term, :author, :notes,
        :alt_term1, :alt_term2, :alt_term3]
  SEARCH_DEFAULT_TRANSLATION_COLUMNS = [:term, :author, :alt_term1, :alt_term2, :alt_term3]

  SEARCH_EXTRA = [:title_translated, :author_translated, :translation_notes]

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

    extra = (options[:extra].presence || []).map(&:to_sym)
    search_contains = (options[:search_contains] == true)

    query = query.to_s.mb_chars.downcase.to_s.strip

    if language.is_base_language?
      return [] if columns.empty?

      condition = GlossaryTitle.base_states_condition(language, states)

      GlossaryTitle.where(condition).list_order.includes([:comments, :language]).select do |term|
        if search_contains
          columns.any?{|field| term.try(field).to_s.mb_chars.downcase.to_s.include?(query) }
        else
          columns.any?{|field| term.try(field).to_s.mb_chars.downcase.to_s.index(query) == 0 }
        end
      end
    else
      translation_columns = options[:translation_columns].presence || SEARCH_TRANSLATION_COLUMNS
      translation_columns = SEARCH_TRANSLATION_COLUMNS if translation_columns.empty?
      translation_columns = translation_columns.map(&:to_sym) & SEARCH_TRANSLATION_COLUMNS

      return [] if (columns + translation_columns).empty?

      condition = GlossaryTitle.non_base_states_condition(language, states)
      extra_condition = GlossaryTitle.extra_condition(language, extra)

      GlossaryTitle.where(condition).where(extra_condition).list_order.includes([:glossary_title_translations, :comments, :language]).select do |term|
        transaction = term.glossary_title_translations.select{|t| t.language_id == language.id}.first

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
    return 'TRUE' if (extra & [:title_translated, :author_translated, :translation_notes]) == 0

    conditions = [%q{
        glossary_title_translations.glossary_title_id = glossary_titles.id AND
        glossary_title_translations.language_id = ?
      }]

    if extra.include?(:author_translated)
      conditions << 'glossary_title_translations.author IS NOT NULL'
    end

    if extra.include?(:translation_notes)
      conditions << 'glossary_title_translations.notes IS NOT NULL'
    end

    [
      %Q{
        EXISTS( SELECT glossary_title_translations.id
          FROM glossary_title_translations
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
    GlossaryTitle.new(
      integration_status: IntegrationStatus.default.first,
      is_private: true
    )
  end

  def has_translations?
    self.glossary_title_translations.count > 0
  end

  def has_no_transaltion?
    self.glossary_title_translations.count == 0
  end

  def translation_for_language(language_id)
    self.glossary_title_translations.by_language(language_id).first ||
    GlossaryTitleTranslation.new_with_defaults
  end

  def translations_except_language(language_id)
    self.glossary_title_translations.except_language(language.id).includes([:language]).sort{|x,y| x.language.iso_code <=> y.language.iso_code}
  end

  def reject!(reason)
    base_language = Language.base_language
    return if self.language_id == base_language.id
     GlossaryTitle.transaction do
      self.rejected_because = reason
      self.is_private = true
      self.save!

      self.translations_except_language(self.language_id).each do |translation|
        t = self.dup
        t.language_id = translation.language_id

        if GlossaryTitle.by_language(translation.language_id).by_term(self.term).first
          t.term = "#{t.term} [DUPLICATE #{SecureRandom.hex(8)}]"
        end
        t.save!
        translation.update_attributes!(glossary_title_id: t.id)
      end
    end
  end
end
