# == Schema Information
#
# Table name: general_menus
#
#  id              :integer          not null, primary key
#  general_menu_id :integer
#  cms_name        :string(255)      not null
#  name            :string(500)      not null
#  sequence        :integer          not null
#  remark          :text
#  created_at      :datetime
#  updated_at      :datetime
#  item_type       :string(255)      default("F"), not null
#  language_id     :integer          default(3), not null
#  synchronized    :boolean          default(FALSE), not null
#  length_type     :string(255)
#  additional_text :text
#  cms_updated     :date
#  wiki_qa         :string(255)
#  full_cms_path   :string(255)
#  online          :date
#

class GeneralMenu < ActiveRecord::Base
  strip_attributes :only => [:cms_name, :name, :remark, :item_type, :length_type, :additional_text, :wiki_qa, :full_cms_path, :online]
  has_paper_trail :ignore => [:created_at, :updated_at]

  belongs_to :language
  belongs_to :general_menu

  has_many :general_menus
  has_many :general_menu_translations
  has_many :general_menu_actions

  has_many :comments, as: :commentable, dependent: :destroy

  scope :by_language, -> (language_id) { where(language_id: language_id) }
  scope :list_order, -> { order('lower(general_menus.name)') }

  validates :cms_name, :name, :language_id, presence: true

  def term
    name
  end

  def is_private?
    false
  end

  def editable?
    !synchronized
  end

  def self.simple_search(language, query)
    if query.blank?
      if language.is_base_language?
        GeneralMenu.by_language(language.id).where(general_menu_id: nil).list_order
      else
        GeneralMenu.where(language_id: [language.id, Language.base_language.id], general_menu_id: nil).list_order.includes([:general_menu_translations])
      end
    else
      search_columns = [:name, :remark, :additional_text, :cms_name, :full_cms_path]
      if language.is_base_language?
        GeneralMenu.by_language(language.id).list_order.select do |item|
          search_columns.collect{|field| item[field].to_s}.join(' ').downcase.include?(query)
        end
      else
        search_transaction_columns = [:name, :notes, :additional_text]
        GeneralMenu.where(language_id: [language.id, Language.base_language.id]).list_order.includes([:general_menu_translations]).select do |item|
          search_columns.collect{|field| item[field].to_s}.join(' ').downcase.include?(query) ||
          (
            (
              transaction = item.general_menu_translations.select{|t| t.language_id == language.id}.first
            ) &&
              search_transaction_columns.collect do |field|
                transaction[field].to_s
              end.join(' ').downcase.include?(query)
            )
        end
      end
    end
  end

  def children(language)
    if language.is_base_language?
      self.general_menus.by_language(language.id).list_order
    else
      self.general_menus.where(language_id: [language.id, Language.base_language.id]).list_order.includes([:general_menu_translations])
    end
  end

  def has_translations?
    self.general_menu_translations.count > 0
  end

  def has_no_transaltion?
    self.general_menu_translations.count == 0
  end

  def translation_for_language(language_id)
    self.general_menu_translations.by_language(language_id).first ||
    GeneralMenuTranslation.new_with_defaults
  end

  def translations_except_language(language_id)
    self.general_menu_translations.except_language(language.id).includes([:language]).sort{|x,y| x.language.iso_code <=> y.language.iso_code}
  end


  def level
    full_cms_path.split('/').length
  end

  def folder?
    item_type == 'F'
  end

  def item_type_name
    case item_type
    when 'F'
      :folder
    when 'A'
      :audio
    when 'V'
      :video
    else
      :article
    end
  end

  def fa_icon
    case item_type
    when 'F'
      'fa-folder-o'
    when 'A'
      'fa-file-audio-o'
    when 'V'
      'fa-file-movie-o'
    else
      'fa-file-text-o'
    end
  end
end
