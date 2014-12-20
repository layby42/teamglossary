# == Schema Information
#
# Table name: integration_statuses
#
#  id          :integer          not null, primary key
#  code        :string(255)      not null
#  name        :string(255)      not null
#  description :text
#  is_default  :boolean          default(FALSE), not null
#  created_at  :datetime
#  updated_at  :datetime
#

class IntegrationStatus < ActiveRecord::Base
  strip_attributes :only => [:code, :name, :description]
  has_paper_trail :ignore => [:created_at, :updated_at]

  scope :list_order, -> { order('lower(integration_statuses.name)') }
  scope :default, -> { where(is_default: true) }

  validates :name, presence: true, length: {maximum: 100}
  validates :code, presence: true, length: {maximum: 3}, uniqueness: {case_sensitive: false}

  def fix_default!
    IntegrationStatus.default.each do |item|
      next if item.id == self.id
      item.update_attributes!(is_default: false)
    end
  end

  def self.full_name_csv(code)
    code_names = IntegrationStatus.pluck(:code, :name).collect{|p| "#{p[0]} – #{p[1]}" }.join('; ')
    "Status of #{code} term change integrated into #{code} articles: #{code_names}"
  end
end
