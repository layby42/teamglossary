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
#

class GlossaryType < ActiveRecord::Base
  scope :list_order, -> { order('lower(glossary_types.name)') }

  validates :code, presence: true, uniqueness: {case_sensitive: false}
  validates :name, presence: true, uniqueness: {case_sensitive: false}

  def glossary_class
    case code
    when 'PPN'
      GlossaryName
    when 'THT'
      GlossaryTerm
    when 'TXT'
      GlossaryTitle
    end
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
end
