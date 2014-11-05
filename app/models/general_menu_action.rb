# == Schema Information
#
# Table name: general_menu_actions
#
#  id              :integer          not null, primary key
#  language_id     :integer
#  general_menu_id :integer
#  action          :string(255)
#  name            :string(255)
#  start_date      :date
#  end_date        :date
#  created_at      :datetime
#  updated_at      :datetime
#  user_id         :integer
#

class GeneralMenuAction < ActiveRecord::Base
end
