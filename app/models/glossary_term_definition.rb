# == Schema Information
#
# Table name: glossary_term_definitions
#
#  id               :integer          not null, primary key
#  glossary_term_id :integer
#  definition       :text             not null
#  is_private       :boolean          default(FALSE), not null
#  created_at       :datetime
#  updated_at       :datetime
#

class GlossaryTermDefinition < ActiveRecord::Base
  belongs_to :glossary_term
  has_many :glossary_term_definition_translations
end
