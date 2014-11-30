# == Schema Information
#
# Table name: proper_name_types
#
#  id          :integer          not null, primary key
#  code        :string(3)        not null
#  name        :string(100)      not null
#  description :string(2000)
#  is_default  :boolean          default(FALSE), not null
#  created_at  :datetime
#  updated_at  :datetime
#

class ProperNameType < ActiveRecord::Base

  strip_attributes :only => [:code, :name, :description]
  has_paper_trail :ignore => [:created_at, :updated_at]

  scope :list_order, -> { order('lower(proper_name_types.name)') }
  scope :default, -> { where(is_default: true) }

  validates :name, presence: true, length: {maximum: 100}
  validates :code, presence: true, length: {maximum: 3}, uniqueness: {case_sensitive: false}

  def fix_default!
    ProperNameType.default.each do |item|
      next if item.id == self.id
      item.update_attributes!(is_default: false)
    end
  end
end
