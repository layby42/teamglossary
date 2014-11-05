# == Schema Information
#
# Table name: settings
#
#  id                :integer          not null, primary key
#  configurable_id   :integer
#  configurable_type :string(255)
#  name              :string(40)       not null
#  value             :string(255)
#  value_type        :string(255)
#

class Setting < ActiveRecord::Base
end
