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
  has_paper_trail :ignore => [:created_at, :updated_at]

  belongs_to :language
  belongs_to :proper_name_type
  belongs_to :integration_status

  has_many :glossary_name_translations
  has_many :comments, as: :commentable

  scope :list_order, -> { order('lower(glossary_names.term)') }

  validates :term, :language_id, :proper_name_type_id, presence: true

  def self.simple_search(language, query)
    search_columns = [:term, :tibetan, :sanskrit, :explanation, :wade_giles, :dates]

    if language.is_base_language?
      GlossaryName.where(%Q{
        (glossary_names.language_id = ? OR
         NOT glossary_names.is_private)
        }, language.id).list_order.includes([:proper_name_type]).select do |term|
        search_columns.collect{|field| term[field].to_s}.join(' ').downcase.include?(query)
      end
    else
      search_transaction_columns = [:term, :alt_term1, :alt_term2, :alt_term3, :notes]
      GlossaryName.where(%Q{
        (glossary_names.language_id = ? OR
          ( glossary_names.language_id = ? AND
            NOT glossary_names.is_private)
          )
        }, language.id, Language.base_language.id).list_order.includes([:glossary_name_translations, :proper_name_type]).select do |term|

          search_columns.collect{|field| term[field].to_s}.join(' ').downcase.include?(query) ||
          (
            (
              transaction = term.glossary_name_translations.select{|t| t.language_id == language.id}.first) &&
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
    GlossaryName.new(
      integration_status: IntegrationStatus.default.first,
      proper_name_type: ProperNameType.default.first
    )
  end
end
