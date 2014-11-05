# == Schema Information
#
# Table name: general_menus
#
#  id              :integer          not null, primary key
#  general_menu_id :integer
#  cms_name        :string(255)      not null
#  name            :string(500)      not null
#  sequence        :integer          not null
#  remark          :text
#  created_at      :datetime
#  updated_at      :datetime
#  item_type       :string(255)      default("F"), not null
#  language_id     :integer          default(3), not null
#  synchronized    :boolean          default(FALSE), not null
#  length_type     :string(255)
#  additional_text :text
#  cms_updated     :date
#  wiki_qa         :string(255)
#  full_cms_path   :string(255)
#  online          :date
#

class GeneralMenu < ActiveRecord::Base
end
