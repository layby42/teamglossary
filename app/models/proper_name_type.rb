# == Schema Information
#
# Table name: proper_name_types
#
#  id          :integer          not null, primary key
#  code        :string(255)      not null
#  name        :string(255)      not null
#  description :text
#  is_default  :boolean          default(FALSE), not null
#  created_at  :datetime
#  updated_at  :datetime
#  fa_icon     :string(100)      default("fa-flag"), not null
#

class ProperNameType < ActiveRecord::Base
  validates :name, presence: true
  validates :code, presence: true, uniqueness: {case_sensitive: false}
end
