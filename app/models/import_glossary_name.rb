# == Schema Information
#
# Table name: import_glossary_names
#
#  id                                :integer          not null, primary key
#  import_id                         :integer          not null
#  proper_name_type_id               :integer          not null
#  integration_status_id             :integer          not null
#  glossary_name_id                  :integer
#  translation_integration_status_id :integer
#  term                              :string(255)      not null
#  tibetan                           :string(255)
#  sanskrit                          :string(255)
#  wade_giles                        :string(255)
#  dates                             :string(255)
#  term_created_at                   :string(255)
#  term_updated_at                   :string(255)
#  term_translation                  :string(255)
#  alt_term1                         :string(255)
#  alt_term2                         :string(255)
#  alt_term3                         :string(255)
#  term_translation_created_at       :string(255)
#  term_translation_updated_at       :string(255)
#  explanation                       :text
#  notes                             :text
#  log                               :text
#  created_at                        :datetime
#  updated_at                        :datetime
#

class ImportGlossaryName < ActiveRecord::Base
end
