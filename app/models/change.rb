# == Schema Information
#
# Table name: versions
#
#  id             :integer          not null, primary key
#  item_type      :string(255)      not null
#  item_id        :integer          not null
#  event          :string(255)      not null
#  whodunnit      :string(255)
#  object         :text
#  object_changes :text
#  created_at     :datetime
#

class Change < PaperTrail::Version
  default_scope -> { order('created_at DESC') }
  scope :for_item, ->(item) { where(:item => item)}

  def user
    User.find_by_id(whodunnit)
  end
end
