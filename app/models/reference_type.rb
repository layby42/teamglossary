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
  strip_attributes :only => [:code, :name, :description]
  has_paper_trail :ignore => [:created_at, :updated_at]

  scope :list_order, -> { order('lower(reference_types.name)') }
  scope :default, -> { where(is_default: true) }

  validates :name, presence: true, length: {maximum: 100}
  validates :code, presence: true, length: {maximum: 3}, uniqueness: {case_sensitive: false}

  def fix_default!
    ReferenceType.default.each do |item|
      next if item.id == self.id
      item.update_attributes!(is_default: false)
    end
  end

  def self.full_name_csv
    code_names = ReferenceType.pluck(:code, :name).collect{|p| "#{p[0]} – #{p[1]}" }.join('; ')
    "Reference type of terms: #{code_names}"
  end
end
