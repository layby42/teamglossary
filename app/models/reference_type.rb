# == Schema Information
#
# Table name: reference_types
#
#  id          :integer          not null, primary key
#  code        :string(255)      not null
#  name        :string(255)      not null
#  description :text
#  is_default  :boolean          default(FALSE), not null
#  created_at  :datetime
#  updated_at  :datetime
#

class ReferenceType < ActiveRecord::Base
end
