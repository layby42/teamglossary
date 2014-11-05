# == Schema Information
#
# Table name: glossary_term_translations
#
#  id                    :integer          not null, primary key
#  language_id           :integer          not null
#  glossary_term_id      :integer          not null
#  integration_status_id :integer          not null
#  term                  :string(255)      not null
#  created_at            :datetime
#  updated_at            :datetime
#  alt_term1             :string(255)
#  alt_term2             :string(255)
#  alt_term3             :string(255)
#  notes                 :text
#  term_gender           :string(255)
#

class GlossaryTermTranslation < ActiveRecord::Base
  belongs_to :language
  belongs_to :glossary_term
  belongs_to :integration_status
end
