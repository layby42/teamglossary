# == Schema Information
#
# Table name: sanskrit_statuses
#
#  id          :integer          not null, primary key
#  code        :string(255)      not null
#  name        :string(255)      not null
#  description :text
#  is_default  :boolean          default(FALSE), not null
#  created_at  :datetime
#  updated_at  :datetime
#

class SanskritStatus < ActiveRecord::Base
  strip_attributes :only => [:code, :name, :description]
  has_paper_trail :ignore => [:created_at, :updated_at]

  scope :list_order, -> { order('lower(sanskrit_statuses.name)') }
  scope :default, -> { where(is_default: true) }

  validates :name, presence: true, length: {maximum: 100}
  validates :code, presence: true, length: {maximum: 3}, uniqueness: {case_sensitive: false}

  def fix_default!
    SanskritStatus.default.each do |item|
      next if item.id == self.id
      item.update_attributes!(is_default: false)
    end
  end

  def self.full_name_csv
    code_names = SanskritStatus.pluck(:code, :name).collect{|p| "#{p[0]} – #{p[1]}" }.join('; ')
    "Sanskrit / Tibetan status: #{code_names}"
  end
end
