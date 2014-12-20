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
#  sanskrit_gender        :string(255)
#  pali_gender            :string(255)
#  definition             :text
#  is_definition_private  :boolean          default(FALSE), not null
#

class GlossaryTerm < ActiveRecord::Base
  include Approval

  strip_attributes :only => [:term, :tibetan, :sanskrit, :pali, :arabic, :alternative_tibetan, :alternative_sanskrit, :additional_explanation, :sanskrit_gender, :pali_gender, :definition]
  has_paper_trail :ignore => [:created_at, :updated_at]

  belongs_to :language
  belongs_to :reference_type
  belongs_to :integration_status
  belongs_to :general_status
  belongs_to :glossary_term
  belongs_to :sanskrit_status

  has_many :glossary_term_translations
  has_many :comments, as: :commentable
  has_many :glossary_terms

  scope :list_order, -> { order('lower(glossary_terms.term)') }

  validates :term, :language_id, presence: true
  validates :term, uniqueness: {case_sensitive: false, scope: :language_id}

  def self.simple_search(language, query)
    search_columns = [:term, :tibetan, :sanskrit, :pali, :arabic,
      :alternative_tibetan, :alternative_sanskrit, :additional_explanation, :definition]

    if language.is_base_language?
      GlossaryTerm.where(%Q{
        (glossary_terms.language_id = ? OR
         NOT glossary_terms.is_private)
        }, language.id).list_order.select do |term|
        search_columns.collect{|field| term[field].to_s}.join(' ').downcase.include?(query)
      end
    else
      search_transaction_columns = [:term, :alt_term1, :alt_term2, :alt_term2, :notes, :definition]
      GlossaryTerm.where(%Q{
        (glossary_terms.language_id = ? OR
          ( glossary_terms.language_id = ? AND
            NOT glossary_terms.is_private)
          )
        }, language.id, Language.base_language.id).list_order.includes([:glossary_term_translations]).select do |term|

          search_columns.collect{|field| term[field].to_s}.join(' ').downcase.include?(query) ||
          (
            (
              transaction = term.glossary_term_translations.select{|t| t.language_id == language.id}.first) &&
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

  def not_translated_languages(except_language_id=nil)
    language_ids = glossary_term_translations.pluck(:language_id)
    language_ids << except_language_id if except_language_id.present?
    return [] if language_ids.empty?
    Language.active.non_base.except_languages(language_ids)
  end

  def self.new_with_defaults
    GlossaryTerm.new(
      integration_status: IntegrationStatus.default.first,
      reference_type: ReferenceType.default.first,
      general_status: GeneralStatus.default.first,
      sanskrit_status: SanskritStatus.default.first
    )
  end
end
