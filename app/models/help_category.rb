# == Schema Information
#
# Table name: help_categories
#
#  id               :integer          not null, primary key
#  title            :string(255)      not null
#  glossary_type_id :integer
#  sorting          :integer          default(0), not null
#  created_at       :datetime
#  updated_at       :datetime
#

class HelpCategory < ActiveRecord::Base
  strip_attributes :only => [:title]
  has_paper_trail :ignore => [:created_at, :updated_at]

  belongs_to :glossary_type
  has_many :help_articles

  scope :list_order, -> {order('help_categories.sorting')}

  validates :title, presence: true
end
