# == Schema Information
#
# Table name: import_settings
#
#  id               :integer          not null, primary key
#  glossary_type_id :integer          not null
#  csv_column       :integer          not null
#  name             :string(255)      not null
#  description      :text             not null
#  default          :string(255)      not null
#  is_base          :boolean          default(FALSE), not null
#  is_required      :boolean          default(FALSE), not null
#  type_of_data     :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  column_name      :string(255)      default("log")
#

class ImportSetting < ActiveRecord::Base
end
