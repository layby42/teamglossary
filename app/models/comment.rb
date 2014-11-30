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
  belongs_to :commentable, :polymorphic => true
  belongs_to :language
  belongs_to :user

  scope :by_language, -> (language_id) { where(language_id: language_id) }
  scope :list_order, -> { order('comments.created_at DESC') }

end
