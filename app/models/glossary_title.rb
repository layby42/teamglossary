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
#  rejected_because       :text
#

class GlossaryTitle < ActiveRecord::Base
  include Approval

  strip_attributes :only => [:term, :alt_term1, :alt_term2, :popular_term, :author, :author_translit, :tibetan_full, :tibetan_short, :sanskrit_full, :sanskrit_short, :sanskrit_full_diacrit, :sanskrit_short_diacrit, :pali, :explanation, :rejected_because]
  has_paper_trail :ignore => [:created_at, :updated_at]

  belongs_to :language
  belongs_to :integration_status

  has_many :glossary_title_translations
  has_many :comments, as: :commentable, dependent: :destroy

  scope :by_language, -> (language_id) { where(language_id: language_id) }
  scope :by_term, -> (term) { where('lower(glossary_titles.term) = ?', term.downcase) }
  scope :list_order, -> { order('lower(glossary_titles.term)') }

  validates :term, :language_id, :integration_status_id, presence: true
  validates :term, uniqueness: {case_sensitive: false, scope: :language_id, message: 'term already exists'}

  def editable?
    true
  end

  def self.simple_search(language, query)
    search_columns = [ :term, :author, :author_translit,
      :tibetan_full, :tibetan_short,
      :sanskrit_full, :sanskrit_short,
      :sanskrit_full_diacrit, :sanskrit_short_diacrit,
      :explanation, :alt_term1, :alt_term2,
      :popular_term, :pali]

    if language.is_base_language?
      GlossaryTitle.where(%Q{
        (glossary_titles.language_id = ? OR
         NOT glossary_titles.is_private)
        }, language.id).list_order.select do |term|
        search_columns.collect{|field| term[field].to_s}.join(' ').downcase.include?(query)
      end
    else
      search_transaction_columns = [ :term, :author, :notes,
        :alt_term1, :alt_term2, :alt_term3]

      GlossaryTitle.where(%Q{
        (glossary_titles.language_id = ? OR
          ( glossary_titles.language_id = ? AND
            NOT glossary_titles.is_private)
          )
        }, language.id, Language.base_language.id).list_order.includes([:glossary_title_translations]).select do |term|

          search_columns.collect{|field| term[field].to_s}.join(' ').downcase.include?(query) ||
          (
            (
              transaction = term.glossary_title_translations.select{|t| t.language_id == language.id}.first) &&
              search_transaction_columns.collect do |field|
                transaction[field].to_s
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
