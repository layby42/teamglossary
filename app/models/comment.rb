# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  commentable_id   :integer
#  language_id      :integer
#  user_id          :integer
#  commentable_type :string(255)
#  text             :text
#  created_at       :datetime
#  updated_at       :datetime
#

class Comment < ActiveRecord::Base
  strip_attributes :only => [:text]
  has_paper_trail :ignore => [:created_at, :updated_at]

  belongs_to :commentable, :polymorphic => true
  belongs_to :language
  belongs_to :user

  scope :by_language, -> (language_id) { where(language_id: language_id) }
  scope :for_date_range, ->(from, to) { where(%q{
    comments.created_at BETWEEN ? AND ?
    }, from.beginning_of_day, to.end_of_day) }

  scope :list_order, -> { order('comments.created_at DESC') }

  validates :commentable_id, :commentable_type, :language_id, :user_id, :text, presence: true

  def self.simple_search(language, from, to)
    Comment.by_language(language.id).for_date_range(from, to).list_order.includes([:commentable, :user])
  end
end
