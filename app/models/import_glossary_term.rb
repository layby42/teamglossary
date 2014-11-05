# == Schema Information
#
# Table name: import_glossary_terms
#
#  id                                :integer          not null, primary key
#  import_id                         :integer          not null
#  reference_type_id                 :integer          not null
#  general_status_id                 :integer          not null
#  sanskrit_status_id                :integer          not null
#  integration_status_id             :integer          not null
#  glossary_term_id                  :integer
#  glossary_main_term_id             :integer
#  translation_integration_status_id :integer
#  term                              :string(255)      not null
#  tibetan                           :string(255)
#  sanskrit                          :string(255)
#  pali                              :string(255)
#  arabic                            :string(255)
#  term_created_at                   :string(255)
#  term_updated_at                   :string(255)
#  definition                        :text
#  definition_created_at             :string(255)
#  definition_updated_at             :string(255)
#  term_translation                  :string(255)
#  term_translation_created_at       :string(255)
#  term_translation_updated_at       :string(255)
#  definition_translation            :text
#  definition_translation_created_at :string(255)
#  definition_translation_updated_at :string(255)
#  additional_explanation            :text
#  notes                             :text
#  log                               :text
#  created_at                        :datetime
#  updated_at                        :datetime
#  alternative_tibetan               :string(255)
#  alternative_sanskrit              :string(255)
#  alt_term1                         :string(255)
#  alt_term2                         :string(255)
#  alt_term3                         :string(255)
#

class ImportGlossaryTerm < ActiveRecord::Base
end
