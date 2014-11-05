# == Schema Information
#
# Table name: glossary_term_definition_translations
#
#  id                          :integer          not null, primary key
#  language_id                 :integer          not null
#  glossary_term_definition_id :integer          not null
#  definition                  :text             not null
#  created_at                  :datetime
#  updated_at                  :datetime
#

class GlossaryTermDefinitionTranslation < ActiveRecord::Base
  belongs_to :language
  belongs_to :glossary_term_definition
end
