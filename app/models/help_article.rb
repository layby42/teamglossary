# == Schema Information
#
# Table name: help_articles
#
#  id               :integer          not null, primary key
#  help_category_id :integer          not null
#  title            :string(255)      not null
#  body             :text
#  published_at     :datetime
#  created_at       :datetime
#  updated_at       :datetime
#

class HelpArticle < ActiveRecord::Base
  strip_attributes :only => [:title, :body]
  has_paper_trail :ignore => [:created_at, :updated_at]

  belongs_to :help_category

  scope :published, -> {where('help_articles.published_at IS NOT NULL')}
  scope :list_order, -> {order('help_articles.title')}

end
