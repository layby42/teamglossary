# == Schema Information
#
# Table name: glossary_title_translations
#
#  id                    :integer          not null, primary key
#  language_id           :integer          not null
#  glossary_title_id     :integer          not null
#  integration_status_id :integer          not null
#  term                  :string(255)      not null
#  alt_term1             :string(255)
#  alt_term2             :string(255)
#  alt_term3             :string(255)
#  author                :string(255)
#  notes                 :text
#  created_at            :datetime
#  updated_at            :datetime
#

class GlossaryTitleTranslation < ActiveRecord::Base
  belongs_to :language
  belongs_to :glossary_title
  belongs_to :integration_status

  validates :term, :language_id, :glossary_title_id, presence: true
  validates :glossary_title_id, uniqueness: {scope: :language_id, case_sensitive: false}

  def alternative_as_string
    [alt_term1, alt_term2, alt_term3].compact.join(' / ')
  end

end
