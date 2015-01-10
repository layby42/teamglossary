# == Schema Information
#
# Table name: glossary_types
#
#  id          :integer          not null, primary key
#  code        :string(255)      not null
#  name        :string(255)      not null
#  description :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  model_name  :string(255)      not null
#  sorting     :integer          default(0), not null
#

class GlossaryType < ActiveRecord::Base
  strip_attributes :only => [:code, :name, :description, :model_name]

  scope :list_order, -> { order('glossary_types.sorting') }
  scope :except_menu, -> { where(code: ['PPN', 'THT', 'TXT'])}

  validates :code, presence: true, uniqueness: {case_sensitive: false}
  validates :name, presence: true, uniqueness: {case_sensitive: false}

  def glossary_class
    Object.const_get(self.model_name)
  end

  def csv_file_name(language)
    case code
    when 'PPN'
      "#{language.iso_code}_proper_names_glossary_#{Date.today.to_s(:db)}.csv"
    when 'THT'
      "#{language.iso_code}_technical_terms_glossary_#{Date.today.to_s(:db)}.csv"
    when 'TXT'
      "#{language.iso_code}_text_titles_glossary_#{Date.today.to_s(:db)}.csv"
    end
  end

  def general_menu?
    code == 'GM'
  end

  def glossary_search_columns
    case code
    when 'PPN'
      GlossaryName::SEARCH_COLUMNS.map(&:to_s)
    when 'THT'
      GlossaryTerm::SEARCH_COLUMNS.map(&:to_s)
    when 'TXT'
      GlossaryTitle::SEARCH_COLUMNS.map(&:to_s)
    when 'GM'
      GeneralMenu::SEARCH_COLUMNS.map(&:to_s)
    else
      []
    end
  end

  def glossary_search_translation_columns
    case code
    when 'PPN'
      GlossaryName::SEARCH_TRANSLATION_COLUMNS.map(&:to_s)
    when 'THT'
      GlossaryTerm::SEARCH_TRANSLATION_COLUMNS.map(&:to_s)
    when 'TXT'
      GlossaryTitle::SEARCH_TRANSLATION_COLUMNS.map(&:to_s)
    when 'GM'
      GeneralMenu::SEARCH_TRANSLATION_COLUMNS.map(&:to_s)
    else
      []
    end
  end
end
