# == Schema Information
#
# Table name: import_glossary_titles
#
#  id                                :integer          not null, primary key
#  import_id                         :integer          not null
#  integration_status_id             :integer          not null
#  glossary_title_id                 :integer
#  translation_integration_status_id :integer
#  term                              :string(255)      not null
#  term_created_at                   :string(255)
#  term_updated_at                   :string(255)
#  author                            :string(255)
#  author_translit                   :string(255)
#  tibetan_full                      :string(255)
#  tibetan_short                     :string(255)
#  sanskrit_full                     :string(255)
#  sanskrit_short                    :string(255)
#  sanskrit_full_diacrit             :string(255)
#  sanskrit_short_diacrit            :string(255)
#  pali                              :string(255)
#  alt_term1                         :string(255)
#  alt_term2                         :string(255)
#  popular_term                      :string(255)
#  explanation                       :string(255)
#  term_translation                  :string(255)
#  term_translation_created_at       :string(255)
#  term_translation_updated_at       :string(255)
#  alt_term1_translation             :string(255)
#  alt_term2_translation             :string(255)
#  alt_term3_translation             :string(255)
#  author_translation                :string(255)
#  notes                             :string(255)
#  log                               :text
#  created_at                        :datetime
#  updated_at                        :datetime
#

class ImportGlossaryTitle < ActiveRecord::Base
end
