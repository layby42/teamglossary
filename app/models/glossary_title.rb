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
  has_many :comments, as: :commentable

  scope :list_order, -> { order('lower(glossary_titles.term)') }

  validates :term, :language_id, :integration_status_id, presence: true

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
end
