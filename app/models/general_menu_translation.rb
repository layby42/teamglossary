# == Schema Information
#
# Table name: general_menu_translations
#
#  id              :integer          not null, primary key
#  language_id     :integer
#  general_menu_id :integer
#  name            :string(500)      not null
#  online          :date
#  notes           :text
#  created_at      :datetime
#  updated_at      :datetime
#  additional_text :text
#  cms_updated     :date
#  synchronized    :boolean          default(FALSE), not null
#

class GeneralMenuTranslation < ActiveRecord::Base
end
