# == Schema Information
#
# Table name: imports
#
#  id               :integer          not null, primary key
#  glossary_type_id :integer          not null
#  language_id      :integer          not null
#  user_id          :integer
#  file             :string(255)      not null
#  created_at       :datetime
#  updated_at       :datetime
#  skip_rows        :integer          default(0)
#  cols_separator   :string(255)      default(",")
#  note             :text
#  log              :text
#  committer_id     :integer
#  committed_at     :datetime
#  encoding         :string(255)
#  data             :text
#  date_format      :string(255)
#  condition_column :integer
#  condition_option :integer
#  condition_text   :string(255)
#

class Import < ActiveRecord::Base
  belongs_to :language
  belongs_to :glossary_type
  belongs_to :user
  belongs_to :committer, class_name: 'User', foreign_key: :committer_id

  scope :list_order, -> {order('imports.created_at DESC')}

end
