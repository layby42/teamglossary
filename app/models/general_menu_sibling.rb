# == Schema Information
#
# Table name: general_menu_siblings
#
#  id              :integer          not null, primary key
#  general_menu_id :integer
#  sibling_id      :integer          not null
#  sequence        :integer          not null
#  name            :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  full_cms_path   :string(255)
#

class GeneralMenuSibling < ActiveRecord::Base
end
