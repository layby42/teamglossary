# == Schema Information
#
# Table name: general_statuses
#
#  id          :integer          not null, primary key
#  code        :string(255)      not null
#  name        :string(255)      not null
#  description :text
#  is_default  :boolean          default(FALSE), not null
#  is_private  :boolean          default(FALSE), not null
#  created_at  :datetime
#  updated_at  :datetime
#

class GeneralStatus < ActiveRecord::Base
end
