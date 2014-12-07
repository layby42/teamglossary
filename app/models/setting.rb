# == Schema Information
#
# Table name: settings
#
#  id                :integer          not null, primary key
#  configurable_id   :integer          not null
#  configurable_type :string(255)      not null
#  name              :string(250)      not null
#  value             :text
#

class Setting < ActiveRecord::Base
  strip_attributes :only => [:name, :value, :value_type]

  belongs_to :configurable, :polymorphic => true

  scope :by_name, -> (name) { where(name: name) }

  validates :configurable_id, :configurable_type, :name, presence: true

  def self.update_value!(configurable, name, value)
    setting = configurable.settings.by_name(name).first || configurable.settings.new(name: name)
    setting.update_attributes!(value: value)
  end
end
